{-# OPTIONS --safe --without-K #-}
module Finite.Object where

open import Level using (0ℓ)

open import Data.Nat
open import Data.Fin
open import Data.Fin.Patterns using (0F; 1F)
open import Data.Fin.Properties
import Relation.Binary.PropositionalEquality as ≡
open import Data.Product using (uncurry) -- for μ⁻¹∘μ

open import Categorical.Equiv
open import Categorical.Homomorphism hiding (uncurry)

open import Functions 0ℓ


module finite-object-instances where

  instance

    Hₒ : Homomorphismₒ ℕ Set
    Hₒ = record { Fₒ = Fin }

    products : Products ℕ
    products = record { ⊤ = 1 ; _×_ = _*_ }

    productsH : ProductsH ℕ ⟨→⟩
    productsH = record
                  { ε     = λ { tt → zero }
                  ; μ     = uncurry combine
                  ; ε⁻¹   = λ { zero → tt }
                  ; μ⁻¹   = λ {m n} → remQuot n
                  ; ε⁻¹∘ε = λ { tt → ≡.refl }
                  ; ε∘ε⁻¹ = λ { zero → ≡.refl }
                  ; μ⁻¹∘μ = uncurry remQuot-combine
                  ; μ∘μ⁻¹ = λ {m n} → combine-remQuot {m} n
                  }
    -- TODO: Construct productsH from 1↔⊤ and *↔×

    -- TODO: Coproducts
    -- TODO: Exponentials

    boolean : Boolean ℕ
    boolean = record { Bool = 2 }

    booleanH : BooleanH ℕ ⟨→⟩
    booleanH = record
      { β   = bool 0F 1F
      ; β⁻¹ = λ { 0F → 𝕗 ; 1F → 𝕥 }
      }

    strongBooleanH : StrongBooleanH ℕ ⟨→⟩
    strongBooleanH = record
      { β⁻¹∘β = λ { 𝕗  → ≡.refl ; 𝕥  → ≡.refl }
      ; β∘β⁻¹ = λ { 0F → ≡.refl ; 1F → ≡.refl }
      }
