{-# OPTIONS --safe --without-K #-}

module Examples.Add.Properties where

open import Data.Unit using (tt)
open import Data.Product using (_,_)
open import Data.Nat

open import Categorical.Equiv
open import Categorical.Raw
open import Functions.Raw

open import Examples.Add

bval : Bool → ℕ
bval = bool 0 1

val : ∀ n → V Bool n → ℕ
val  zero      tt    = zero
val (suc n) (b , bs) = bval b + val n bs * 2

private
  add : ℕ × ℕ → ℕ
  add = uncurry _+_

open import Relation.Binary.PropositionalEquality renaming (refl to refl≡)
open ≡-Reasoning

module halfAdd where

  i : Bool × Bool → ℕ × ℕ
  i = bval ⊗ bval

  o : Bool × Bool → ℕ
  o (s , cₒ) = bval s + bval cₒ * 2

  _ : i (𝕗 , 𝕥) ≡ (0 , 1)
  _ = refl≡

  _ : o (𝕥 , 𝕥) ≡ 3
  _ = refl≡

  spec : o ∘ halfAdd ≈ add ∘ i
  spec {𝕗 , 𝕗} = refl≡
  spec {𝕗 , 𝕥} = refl≡
  spec {𝕥 , 𝕗} = refl≡
  spec {𝕥 , 𝕥} = refl≡

module fullAdd where

  -- fullAdd : Bool × Bool ⇨ᶜ Bool
  -- fullAdd = second ∨ ∘ inAssocˡ′ halfAdd ∘ second halfAdd
  -- 
  -- λ (c , (a , b)) → let (p , d) = halfAdd (a , b)
  --                       (q , e) = halfAdd (c , p) in (q , e ∨ d)

  i : Bool × (Bool × Bool) → ℕ × (ℕ × ℕ)
  i = bval ⊗ (bval ⊗ bval)

  o : Bool × Bool → ℕ
  o (s , cₒ) = bval s + bval cₒ * 2

  spec : o ∘ fullAdd ≈ (add ∘ second add) ∘ i

  -- spec {c , (a , b)} = {!!}

  spec {𝕗 , 𝕗 , 𝕗} = refl≡
  spec {𝕗 , 𝕗 , 𝕥} = refl≡
  spec {𝕗 , 𝕥 , 𝕗} = refl≡
  spec {𝕗 , 𝕥 , 𝕥} = refl≡
  spec {𝕥 , 𝕗 , 𝕗} = refl≡
  spec {𝕥 , 𝕗 , 𝕥} = refl≡
  spec {𝕥 , 𝕥 , 𝕗} = refl≡
  spec {𝕥 , 𝕥 , 𝕥} = refl≡

module rippleAdd (n : ℕ) where

  -- rippleAdd : ∀ n → V (Bool × Bool) n ⇨ᶜ V Bool n
  -- rippleAdd = ripple fullAdd

  bvalⁿ : Bool → ℕ
  bvalⁿ b = (2 ^ n) * bval b

  valⁿ : V Bool n → ℕ
  valⁿ = val n

  i : Bool × V (Bool × Bool) n → ℕ × (ℕ × ℕ)
  i = bval ⊗ (valⁿ ⊗ valⁿ) ∘ unzipⱽ n

  o : V Bool n × Bool → ℕ
  o = add ∘ (valⁿ ⊗ bvalⁿ)

-- TODO: Replace ℕ by Fin (2 ^ n) throughout this module, and leave the carry
-- bit as a bit.
