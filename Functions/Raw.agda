{-# OPTIONS --safe --without-K #-}

open import Level

module Functions.Raw where

import Function as F
open import Data.Product as × using (_,_; proj₁; proj₂; <_,_>)
import Data.Bool as B

open import Categorical.Raw
open import Categorical.Equiv

open import Functions.Type public

module →-raw-instances where

  instance

    category : Category Function
    category = record { id = F.id ; _∘_ = F._∘′_ }

    cartesian : Cartesian Function
    cartesian = record { exl = proj₁ ; exr = proj₂ ; _▵_ = <_,_> }

    cartesianClosed : CartesianClosed Function
    cartesianClosed = record { curry = ×.curry ; apply = ×.uncurry id }

    logic : Logic Function
    logic = record
              { false = λ tt → 𝕗
              ; true  = λ tt → 𝕥
              ; not   = B.not
              ; ∧     = uncurry B._∧_
              ; ∨     = uncurry B._∨_
              ; xor   = uncurry B._xor_
              ; cond  = λ (c , e , t) → B.if c then t else e
              }

    open import Relation.Binary.PropositionalEquality as ≡ using (_≡_; _≗_)

    equivalent : Equivalent 0ℓ Function
    equivalent = record
      { _≈_ = _≗_
      ; equiv = record
          { refl  = λ _ → ≡.refl
          ; sym   = λ f∼g x → ≡.sym (f∼g x)
          ; trans = λ f∼g g∼h x → ≡.trans (f∼g x) (g∼h x)
          }
      }
