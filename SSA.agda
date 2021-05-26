{-# OPTIONS --safe --without-K #-}

-- Generate static single assignment form from linearized morphism.

-- To insert before Dot.

module SSA where

open import Level using (Level; 0ℓ)
open import Data.Product using (_,_)
open import Data.Fin using (Fin; toℕ; suc; zero)
open import Data.Nat using (ℕ; suc; zero; _+_)
open import Data.String hiding (toList; show)
open import Data.List using
      (List; []; _∷_; upTo; zip; zipWith; reverse; _∷ʳ_)
             renaming (map to mapᴸ; length to lengthᴸ)
open import Data.Bool using (if_then_else_)

open import Categorical.Raw
open import Functions.Raw

open import Ty
open import Index
open import Fun.Type renaming (_⇨_ to _⇨ₜ_)
open import Primitive.Type renaming (_⇨_ to _⇨ₚ_)
open import Routing.Type renaming (_⇨_ to _⇨ᵣ_)

open import Linearize.Type _⇨ₜ_ _⇨ₚ_ _⇨ᵣ_ renaming (_⇨_ to _⇨ₖ_)

private variable a b z : Ty

-- Identifier as component/instance number and output index
record Id (z : Ty) : Set where
  constructor mk
  field
    comp# : ℕ
    {o} : Ty
    j : Index z o

-- An identifier for each index in a Ty
Ref : Ty → Set
Ref = Indexed Id

record Statement : Set where
  constructor mk
  field
    {i o} : Ty
    prim  : i ⇨ₚ o
    ins   : Ref i

record SSA (i o : Ty) : Set where
  constructor mk
  field
    ss : List Statement
    return : Ref o

refs : ℕ → Ref b
refs comp# = tabulate′ (mk comp#)

ssaᵏ : {i : Ty} → ℕ → Ref a → (a ⇨ₖ b) → List Statement → SSA i b
ssaᵏ _ ins ⌞ r ⌟ ss = mk (reverse ss) (⟦ r ⟧′ ins)
ssaᵏ i ins (f ∘·first p ∘ r) ss with ⟦ r ⟧′ ins ; ... | x ､ y =
  ssaᵏ (suc i) (refs i ､ y) f (mk p x ∷ ss)

ssa : (a ⇨ₖ b) → SSA a b
ssa {a} f = ssaᵏ 1 (refs 0) f []

mapℕ : {A B : Set} → (ℕ → A → B) → List A → List B
mapℕ f as = zipWith f (upTo (lengthᴸ as)) as

instance

  open import Show

  Show-Id : ∀ {z} → Show (Id z)
  Show-Id = record { show =
    λ (mk comp#  out#) → "x" ++ show comp# ++ "_" ++ name out# }

  Show-Stmt : Show (ℕ × Statement)
  Show-Stmt = record { show = 
    λ (comp# , mk {o = o} prim ins) →
         show (refs {o} comp#)
      ++ " = "
      ++ show prim ++ parens (show ins)
   }

  Show-SSA : Show (SSA a b)
  Show-SSA = record { show = λ (mk ss ret) →
    unlines (mapℕ (curry show) ss ∷ʳ ("return " ++ show ret)) }

-- TODO: sort out what to make private.
