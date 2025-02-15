Martin Escardo 2011.

\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-}

module DecidableAndDetachable where

open import SpartanMLTT

open import Plus-Properties
open import Two-Properties
open import UF-Subsingletons
open import UF-PropTrunc

\end{code}

We look at decidable propositions and subsets (using the terminogy
"detachable" for the latter").

\begin{code}

¬¬-elim : {A : 𝓤 ̇ } → decidable A → ¬¬ A → A
¬¬-elim (inl a) f = a
¬¬-elim (inr g) f = 𝟘-elim(f g)

negation-preserves-decidability : {A : 𝓤 ̇ }
                                → decidable A → decidable(¬ A)
negation-preserves-decidability (inl a) = inr (λ f → f a)
negation-preserves-decidability (inr g) = inl g

which-of : {A : 𝓤 ̇ } {B : 𝓥 ̇ }
        → A + B → Σ \(b : 𝟚) → (b ≡ ₀ → A) × (b ≡ ₁ → B)

which-of (inl a) = ₀ , ((λ r → a) , (λ ()))
which-of (inr b) = ₁ , ((λ ()) , (λ r → b))

\end{code}

Notice that in Agda the term λ () is a proof of an implication that
holds vacuously, by virtue of the premise being false.  In the above
example, the first occurrence is a proof of ₀ ≡ ₁ → B, and the second
one is a proof of ₁ ≡ ₀ → A.

The following is a special case we are interested in:

\begin{code}

boolean-value : {A : 𝓤 ̇ }
            → decidable A → Σ \(b : 𝟚) → (b ≡ ₀ → A) × (b ≡ ₁ → ¬ A)
boolean-value = which-of

\end{code}

Notice that this b is unique (Agda exercise) and that the converse
also holds. In classical mathematics it is posited that all
propositions have binary truth values, irrespective of whether they
have BHK-style witnesses. And this is precisely the role of the
principle of excluded middle in classical mathematics.  The following
requires choice, which holds in BHK-style constructive mathematics:

\begin{code}

indicator : {X : 𝓤 ̇ } → {A B : X → 𝓥 ̇ }
          → ((x : X) → A x + B x)
          → Σ \(p : X → 𝟚) → (x : X) → (p x ≡ ₀ → A x) × (p x ≡ ₁ → B x)
indicator {𝓤} {𝓥} {X} {A} {B} h = (λ x → pr₁(lemma₁ x)) , (λ x → pr₂(lemma₁ x))
 where
  lemma₀ : (x : X) → (A x + B x) → Σ \b → (b ≡ ₀ → A x) × (b ≡ ₁ → B x)
  lemma₀ x = which-of

  lemma₁ : (x : X) → Σ \b → (b ≡ ₀ → A x) × (b ≡ ₁ → B x)
  lemma₁ = λ x → lemma₀ x (h x)

\end{code}

We again have a particular case of interest.  Detachable subsets,
defined below, are often known as decidable subsets. Agda doesn't
allow overloading of terminology, and hence we gladly accept the
slighly non-universal terminology.

\begin{code}

detachable : {X : 𝓤 ̇ } (A : X → 𝓥 ̇ ) → 𝓤 ⊔ 𝓥 ̇
detachable A = ∀ x → decidable(A x)

characteristic-function : {X : 𝓤 ̇ } {A : X → 𝓥 ̇ }
  → detachable A → Σ \(p : X → 𝟚) → (x : X) → (p x ≡ ₀ → A x) × (p x ≡ ₁ → ¬(A x))
characteristic-function = indicator

co-characteristic-function : {X : 𝓤 ̇ } {A : X → 𝓥 ̇ }
  → detachable A → Σ \(p : X → 𝟚) → (x : X) → (p x ≡ ₀ → ¬(A x)) × (p x ≡ ₁ → A x)
co-characteristic-function d = indicator(λ x → +-commutative(d x))

decidable-closed-under-Σ : {X : 𝓤 ̇ } {Y : X → 𝓥 ̇ } → is-prop X
                         → decidable X → ((x : X) → decidable (Y x)) → decidable (Σ Y)
decidable-closed-under-Σ {𝓤} {𝓥} {X} {Y} isp d e = g d
 where
  g : decidable X → decidable (Σ Y)
  g (inl x) = h (e x)
   where
    φ : Σ Y → Y x
    φ (x' , y) = transport Y (isp x' x) y

    h : decidable(Y x) → decidable (Σ Y)
    h (inl y) = inl (x , y)
    h (inr v) = inr (contrapositive φ v)

  g (inr u) = inr (contrapositive pr₁ u)

\end{code}

Notice that p is unique (Agda exercise - you will need function
extensionality).

Don't really have a good place to put this:

\begin{code}

module _ (pt : propositional-truncations-exist) where

 open PropositionalTruncation pt

 not-exists₀-implies-forall₁ : {X : 𝓤 ̇ } (p : X → 𝟚)
                            → ¬ (∃ \(x : X) → p x ≡ ₀) → (∀ (x : X) → p x ≡ ₁)
 not-exists₀-implies-forall₁ p u x = different-from-₀-equal-₁ (not-Σ-implies-Π-not (u ∘ ∣_∣) x)

 forall₁-implies-not-exists₀ : {X : 𝓤 ̇ } (p : X → 𝟚)
                            → (∀ (x : X) → p x ≡ ₁) → ¬ ∃ \(x : X) → p x ≡ ₀
 forall₁-implies-not-exists₀ p α = ∥∥-rec 𝟘-is-prop h
  where
   h : (Σ \x → p x ≡ ₀) → 𝟘
   h (x , r) = zero-is-not-one (r ⁻¹ ∙ α x)

\end{code}
