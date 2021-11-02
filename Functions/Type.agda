{-# OPTIONS --safe --without-K #-}

open import Level

module Functions.Type (ℓ : Level) where

import Data.Unit as U
open import Data.Unit.Polymorphic using () renaming (⊤ to ⊤′)
open import Data.Product using () renaming (_×_ to _×′_)

import Data.Bool as B

⟨→⟩ : Set ℓ → Set ℓ → Set ℓ
⟨→⟩ a b = a → b

Function : Set ℓ → Set ℓ → Set ℓ
Function = ⟨→⟩

pattern 𝕗 = lift B.false
pattern 𝕥 = lift B.true

pattern tt = lift U.tt

infix  0 if_then_else_

if_then_else_ :  ∀ {a}{A : Set a} → Lift ℓ B.Bool → A → A → A
if 𝕥 then t else f = t
if 𝕗 then t else f = f

bool : ∀ {a}{A : Set a} → A → A → Lift ℓ B.Bool → A
bool e t c = if c then t else e

lift₁ : ∀ {a b}{A : Set a}{B : Set b}{a′ b′}
      → (A → B) → (Lift a′ A → Lift b′ B)
lift₁ f (lift x) = lift (f x)

lift₂ : ∀ {a b c}{A : Set a}{B : Set b}{C : Set c}{a′ b′ c′}
      → (A → B → C) → (Lift a′ A → Lift b′ B → Lift c′ C)
lift₂ f (lift x) (lift y) = lift (f x y)

open import Function
open import Relation.Binary.PropositionalEquality
open ≡-Reasoning

-- Functions with left inverses are injective. TODO: maybe generalize to monic morphisms.
invertible-injective : ∀ {A B : Set ℓ} (f : A → B) (f⁻¹ : B → A) (f⁻¹∘f≗id : f⁻¹ ∘ f ≗ id) →
  ∀ {x y} → f x ≡ f y → x ≡ y
invertible-injective f f⁻¹ f⁻¹∘f≗id {x} {y} fx≡fy =
  begin
    x
  ≡⟨ sym (f⁻¹∘f≗id x) ⟩
    f⁻¹ (f x)
  ≡⟨ cong f⁻¹ fx≡fy ⟩
    f⁻¹ (f y)
  ≡⟨ f⁻¹∘f≗id y ⟩
    y
  ∎

module →-instances where

  open import Categorical.Object

  instance

    products : Products (Set ℓ)
    products = record { ⊤ = ⊤′ ; _×_ = _×′_ }

    exponentials : Exponentials (Set ℓ)
    exponentials = record { _⇛_ = Function }

    boolean : Boolean (Set ℓ)
    boolean = record { Bool = Lift ℓ B.Bool }
