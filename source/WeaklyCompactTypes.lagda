Martin Escardo, January 2018

Two weak notions of compactness: ∃-compactness and Π-compactness. See
the module CompactTypes for the strong notion.

\begin{code}

{-# OPTIONS --without-K --exact-split --safe #-}

open import SpartanMLTT

open import CompactTypes
open import TotallySeparated
open import Two-Properties
open import DiscreteAndSeparated
open import GenericConvergentSequence
open import WLPO
open import UF-FunExt
open import UF-PropTrunc
open import UF-Retracts
open import UF-Retracts-FunExt
open import UF-ImageAndSurjection
open import UF-Equiv
open import UF-Miscelanea

module WeaklyCompactTypes
        (fe : FunExt)
        (pt : propositional-truncations-exist)
       where

open PropositionalTruncation pt
open import DecidableAndDetachable

∃-compact : 𝓤 ̇ → 𝓤 ̇
∃-compact X = (p : X → 𝟚) → decidable (∃ \(x : X) → p x ≡ ₀)

∃-compactness-is-a-prop : {X : 𝓤 ̇ } → is-prop (∃-compact X)
∃-compactness-is-a-prop {𝓤} {X} = Π-is-prop (fe 𝓤 𝓤)
                                (λ _ → decidability-of-prop-is-prop (fe 𝓤 𝓤₀) ∥∥-is-a-prop)

∃-compact-Markov : {X : 𝓤 ̇ }
                 → ∃-compact X
                 → (p : X → 𝟚)
                 → ¬¬(∃ \(x : X) → p x ≡ ₀)
                 → ∃ \(x : X) → p x ≡ ₀
∃-compact-Markov {𝓤} {X} c p φ = g (c p)
 where
  g : decidable (∃ \(x : X) → p x ≡ ₀) → ∃ \(x : X) → p x ≡ ₀
  g (inl e) = e
  g (inr u) = 𝟘-elim (φ u)

\end{code}

The relation of ∃-compactness with compactness is the same as that of
LPO with WLPO.

\begin{code}

Π-compact : 𝓤 ̇ → 𝓤 ̇
Π-compact X = (p : X → 𝟚) → decidable ((x : X) → p x ≡ ₁)

Π-compactness-is-a-prop : {X : 𝓤 ̇ } → is-prop (Π-compact X)
Π-compactness-is-a-prop {𝓤} = Π-is-prop (fe 𝓤 𝓤)
                         (λ _ → decidability-of-prop-is-prop (fe 𝓤 𝓤₀)
                                  (Π-is-prop (fe 𝓤 𝓤₀) λ _ → 𝟚-is-set))

∃-compact-gives-Π-compact : {X : 𝓤 ̇ } → ∃-compact X → Π-compact X
∃-compact-gives-Π-compact {𝓤} {X} c p = f (c p)
 where
  f : decidable (∃ \(x : X) → p x ≡ ₀) → decidable (Π \(x : X) → p x ≡ ₁)
  f (inl s) = inr (λ α → ∥∥-rec 𝟘-is-prop (g α) s)
   where
    g : ((x : X) → p x ≡ ₁) → ¬ Σ \x → p x ≡ ₀
    g α (x , r) = zero-is-not-one (r ⁻¹ ∙ α x)
  f (inr u) = inl (not-exists₀-implies-forall₁ pt p u)

is-empty-∃-compact : {X : 𝓤 ̇ } → is-empty X → ∃-compact X
is-empty-∃-compact u p = inr (∥∥-rec 𝟘-is-prop λ σ → u (pr₁ σ))

empty-Π-compact : {X : 𝓤 ̇ } → is-empty X → Π-compact X
empty-Π-compact u p = inl (λ x → 𝟘-elim (u x))

\end{code}

The ∃-compactness, and hence Π-compactness, of compact sets (and hence
of ℕ∞, for example):

\begin{code}

compact-gives-∃-compact : {X : 𝓤 ̇ } → compact X → ∃-compact X
compact-gives-∃-compact {𝓤} {X} φ p = g (φ p)
 where
  g : ((Σ \(x : X) → p x ≡ ₀) + ((x : X) → p x ≡ ₁)) → decidable (∃ \(x : X) → p x ≡ ₀)
  g (inl (x , r)) = inl ∣ x , r ∣
  g (inr α) = inr (forall₁-implies-not-exists₀ pt p α)

\end{code}

But notice that the Π-compactness of ℕ is WLPO and its ∃-compactness
is amounts to LPO.

The Π-compactness of X is equivalent to the isolatedness of the boolean
predicate λ x → ₁:

\begin{code}

Π-compact' : 𝓤 ̇ → 𝓤 ̇
Π-compact' X = (p : X → 𝟚) → decidable (p ≡ λ x → ₁)

Π-compactness'-is-a-prop : {X : 𝓤 ̇ } → is-prop(Π-compact' X)
Π-compactness'-is-a-prop {𝓤} = Π-is-prop (fe 𝓤 𝓤)
                                (λ p → decidability-of-prop-is-prop (fe 𝓤 𝓤₀)
                                         (Π-is-set (fe 𝓤 𝓤₀) (λ x → 𝟚-is-set)))

Π-compact'-gives-Π-compact : {X : 𝓤 ̇ } → Π-compact' X → Π-compact X
Π-compact'-gives-Π-compact {𝓤} {X} c' p = g (c' p)
 where
  g : decidable (p ≡ λ x → ₁) → decidable ((x : X) → p x ≡ ₁)
  g (inl r) = inl (happly r)
  g (inr u) = inr (contrapositive (dfunext (fe 𝓤 𝓤₀)) u)

Π-compact-gives-Π-compact' : {X : 𝓤 ̇ } → Π-compact X → Π-compact' X
Π-compact-gives-Π-compact' {𝓤} {X} c p = g (c p)
 where
  g : decidable ((x : X) → p x ≡ ₁) → decidable (p ≡ λ x → ₁)
  g (inl α) = inl (dfunext (fe 𝓤 𝓤₀) α)
  g (inr u) = inr (contrapositive happly u)

\end{code}

In classical topology, the Tychonoff Theorem gives that compact to the
power discrete is compact (where we read the function type X → Y as "Y
to the power X", with Y the base and X the exponent, and call it an
exponential). Here we don't have the Tychonoff Theorem (in the absence
of anti-classical intuitionistic assumptions).

It is less well-known that in classical topology we also have that
discrete to the power compact is discrete. This we do have here,
without the need of any assumption:

\begin{code}

cdd : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } → Π-compact X → is-discrete Y → is-discrete(X → Y)
cdd {𝓤} {𝓥} {X} {Y} c d f g = h (c p)
 where
  p : X → 𝟚
  p = pr₁ (co-characteristic-function (λ x → d (f x) (g x)))
  r : (x : X) → (p x ≡ ₀ → ¬ (f x ≡ g x)) × (p x ≡ ₁ → f x ≡ g x)
  r = pr₂ (co-characteristic-function λ x → d (f x) (g x))
  φ : ((x : X) → p x ≡ ₁) → f ≡ g
  φ α = (dfunext (fe 𝓤 𝓥) (λ x → pr₂ (r x) (α x)))
  γ : f ≡ g → (x : X) → p x ≡ ₁
  γ t x = different-from-₀-equal-₁ (λ u → pr₁ (r x) u (happly t x))
  h : decidable((x : X) → p x ≡ ₁) → decidable (f ≡ g)
  h (inl α) = inl (φ α)
  h (inr u) = inr (contrapositive γ u)

\end{code}

If an exponential with discrete base is discrete, then its exponent is
compact, provided the base has at least two points.

First, to decide Π(p:X→𝟚), p(x)=1, decide p = λ x → ₁:

\begin{code}

d𝟚-Πc : {X : 𝓤 ̇ } → is-discrete(X → 𝟚) → Π-compact X
d𝟚-Πc d = Π-compact'-gives-Π-compact (λ p → d p (λ x → ₁))

\end{code}

A type X has 𝟚 as a retract iff it can be written as X₀+X₁ with X₀ and
X₁ pointed. A sufficient (but by no means necessary) condition for
this is that there is an isolated point x₀ and a point different from
x₀ (in this case the decomposition is with X₀ ≃ 𝟙).

\begin{code}

dcc : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } → retract 𝟚 of Y → is-discrete(X → Y) → Π-compact X
dcc {𝓤} re d = d𝟚-Πc (retract-discrete-discrete (rpe (fe 𝓤 𝓤₀) re) d)

ddc' : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } (y₀ y₁ : Y) → y₀ ≢ y₁
     → is-discrete Y → is-discrete(X → Y) → Π-compact X
ddc' y₀ y₁ ne dy = dcc (𝟚-retract-of-discrete ne dy)

\end{code}

So, in summary, if Y is a non-trivial discrete type, then X is
Π-compact iff (X → Y) is discrete.

Compactness of images:

\begin{code}

open ImageAndSurjection pt

surjection-∃-compact : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } (f : X → Y)
                     → is-surjection f → ∃-compact X → ∃-compact Y
surjection-∃-compact {𝓤} {𝓥} {X} {Y} f su c q = g (c (q ∘ f))
 where
  h : (Σ \(x : X) → q(f x) ≡ ₀) → Σ \(y : Y) → q y ≡ ₀
  h (x , r) = (f x , r)

  l : (y : Y) → q y ≡ ₀ → (Σ \(x : X) → f x ≡ y) → Σ \(x : X) → q (f x) ≡ ₀
  l y r (x , s) = (x , (ap q s ∙ r))

  k : (Σ \(y : Y) → q y ≡ ₀) → ∃ \(x : X) → q (f x) ≡ ₀
  k (y , r) = ∥∥-functor (l y r) (su y)

  g : decidable (∃ \(x : X) → q(f x) ≡ ₀) → decidable (∃ \(y : Y) → q y ≡ ₀)
  g (inl s) = inl (∥∥-functor h s)
  g (inr u) = inr (contrapositive (∥∥-rec ∥∥-is-a-prop k) u)

image-∃-compact : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } (f : X → Y)
               → ∃-compact X → ∃-compact (image f)
image-∃-compact f = surjection-∃-compact (corestriction f) (corestriction-surjection f)

surjection-Π-compact : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } (f : X → Y)
                     → is-surjection f → Π-compact X → Π-compact Y
surjection-Π-compact {𝓤} {𝓥} {X} {Y} f su c q = g (c (q ∘ f))
 where
  g : decidable((x : X) → q (f x) ≡ ₁) → decidable ((x : Y) → q x ≡ ₁)
  g (inl s) = inl (surjection-induction f su (λ y → q y ≡ ₁) (λ _ → 𝟚-is-set) s)
  g (inr u) = inr (contrapositive (λ φ x → φ (f x)) u)

retract-∃-compact : {X : 𝓤 ̇ } {Y : 𝓥 ̇ }
                  → retract Y of X → ∃-compact X → ∃-compact Y
retract-∃-compact (f , hass) = surjection-∃-compact f (retraction-surjection f hass)

retract-∃-compact' : {X : 𝓤 ̇ } {Y : 𝓥 ̇ }
                   → ∥ retract Y of X ∥ → ∃-compact X → ∃-compact Y
retract-∃-compact' t c = ∥∥-rec ∃-compactness-is-a-prop (λ r → retract-∃-compact r c) t

image-Π-compact : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } (f : X → Y)
                → Π-compact X → Π-compact (image f)
image-Π-compact f = surjection-Π-compact (corestriction f) (corestriction-surjection f)

retract-Π-compact : {X : 𝓤 ̇ } {Y : 𝓥 ̇ }
                  → retract Y of X → Π-compact X → Π-compact Y
retract-Π-compact (f , hass) = surjection-Π-compact f (retraction-surjection f hass)

retract-Π-compact' : {X : 𝓤 ̇ } {Y : 𝓥 ̇ }
                  → ∥ retract Y of X ∥ → Π-compact X → Π-compact Y
retract-Π-compact' t c = ∥∥-rec Π-compactness-is-a-prop (λ r → retract-Π-compact r c) t

i2c2c : {X : 𝓤 ̇ } {Y : 𝓥 ̇ }
      → X → Π-compact (X → Y) → Π-compact Y
i2c2c x = retract-Π-compact (pdrc x)

\end{code}

A main reason to consider the notion of total separatedness is that
the totally separated reflection 𝕋 X of X has the same supply of
boolean predicates as X, and hence X is ∃-compact (respectively
Π-compact) iff 𝕋 X is, as we show now.

\begin{code}

module TStronglyOvertnessAndCompactness (X : 𝓤 ̇ ) where

 open TotallySeparatedReflection fe pt

 extension : (X → 𝟚) → (𝕋 X → 𝟚)
 extension p = pr₁ (pr₁ (totally-separated-reflection 𝟚-is-totally-separated p))

 extension-property : (p : X → 𝟚) (x : X) → extension p (η x) ≡ p x
 extension-property p = happly (pr₂ (pr₁ (totally-separated-reflection 𝟚-is-totally-separated p)))

 sot : ∃-compact X → ∃-compact (𝕋 X)
 sot = surjection-∃-compact η (η-surjection)

 tos : ∃-compact (𝕋 X) → ∃-compact X
 tos c p = h (c (extension p))
  where
   f : (Σ \(x' : 𝕋 X) → extension p x' ≡ ₀) → ∃ \(x : X) → p x ≡ ₀
   f (x' , r) = ∥∥-functor f' (η-surjection x')
    where
     f' : (Σ \(x : X) → η x ≡ x') → Σ \(x : X) → p x ≡ ₀
     f' (x , s) = x , ((extension-property p x) ⁻¹ ∙ ap (extension p) s ∙ r)

   g : (Σ \(x : X) → p x ≡ ₀) → Σ \(x' : 𝕋 X) → extension p x' ≡ ₀
   g (x , r) = η x , (extension-property p x ∙ r)

   h : decidable (∃ \(x' : 𝕋 X) → extension p x' ≡ ₀) → decidable (∃ \(x : X) → p x ≡ ₀)
   h (inl x) = inl (∥∥-rec ∥∥-is-a-prop f x)
   h (inr u) = inr (contrapositive (∥∥-functor g) u)

 ct : Π-compact X → Π-compact (𝕋 X)
 ct = surjection-Π-compact η (η-surjection)

 tc : Π-compact (𝕋 X) → Π-compact X
 tc c p = h (c (extension p))
  where
   f : ((x' : 𝕋 X) → extension p x' ≡ ₁) → ((x : X) → p x ≡ ₁)
   f α x = (extension-property p x)⁻¹ ∙ α (η x)

   g : (α : (x : X) → p x ≡ ₁) → ((x' : 𝕋 X) → extension p x' ≡ ₁)
   g α = η-induction (λ x' → extension p x' ≡ ₁) (λ _ → 𝟚-is-set) g'
     where
      g' : (x : X) → extension p (η x) ≡ ₁
      g' x = extension-property p x ∙ α x

   h : decidable ((x' : 𝕋 X) → extension p x' ≡ ₁) → decidable ((x : X) → p x ≡ ₁)
   h (inl α) = inl (f α)
   h (inr u) = inr (contrapositive g u)

\end{code}

If X is totally separated, and (X → 𝟚) is compact, then X is
discrete. More generally, if 𝟚 is a retract of Y and (X → Y) is
compact, then X is discrete if it is totally separated. This is a new
result as far as I know. I didn't know it before 12th January 2018.

The following proof works as follows. For any given x,y:X, define
q:(X→𝟚)→𝟚 such that q(p)=1 ⇔ p(x)=p(y), which is possible because 𝟚
has decidable equality (it is discrete). By the Π-compactness of X→𝟚,
the condition (p:X→𝟚)→q(p)=1 is decidable, which amounts to saying
that (p:X→𝟚) → p(x)=p(y) is decidable. But because X is totally
separated, the latter is equivalent to x=y, which shows that X is
discrete.

\begin{code}

tscd : {X : 𝓤 ̇ } → is-totally-separated X → Π-compact (X → 𝟚) → is-discrete X
tscd {𝓤} {X} ts c x y = g (a s)
 where
  q : (X → 𝟚) → 𝟚
  q = pr₁ (co-characteristic-function (λ p → 𝟚-is-discrete (p x) (p y)))
  r : (p : X → 𝟚) → (q p ≡ ₀ → p x ≢ p y) × (q p ≡ ₁ → p x ≡ p y)
  r = pr₂ (co-characteristic-function (λ p → 𝟚-is-discrete (p x) (p y)))
  s : decidable ((p : X → 𝟚) → q p ≡ ₁)
  s = c q
  b : (p : X → 𝟚) → p x ≡ p y → q p ≡ ₁
  b p u = different-from-₀-equal-₁ (λ v → pr₁ (r p) v u)
  a : decidable ((p : X → 𝟚) → q p ≡ ₁) → decidable((p : X → 𝟚) → p x ≡ p y)
  a (inl f) = inl (λ p → pr₂ (r p) (f p))
  a (inr φ) = inr h
   where
    h : ¬((p : X → 𝟚) → p x ≡ p y)
    h α = φ (λ p → b p (α p))
  g : decidable ((p : X → 𝟚) → p x ≡ p y) → decidable(x ≡ y)
  g (inl α) = inl (ts α)
  g (inr u) = inr (contrapositive (λ e p → ap p e) u)

\end{code}

We are interested in the following two generalizations, which arise as
corollaries:

\begin{code}

tscd₀ : {X : 𝓤₀ ̇ } {Y : 𝓤₀ ̇ } → is-totally-separated X → retract 𝟚 of Y
     → Π-compact (X → Y) → is-discrete X
tscd₀ {X} {Y} ts r c = tscd ts (retract-Π-compact (rpe (fe 𝓤₀ 𝓤₀) r) c)

open TotallySeparatedReflection fe pt

tscd₁ : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } → retract 𝟚 of Y
      → Π-compact (X → Y) → is-discrete (𝕋 X)
tscd₁ {𝓤} {𝓥} {X} {Y} r c = f
 where
  z : retract (X → 𝟚) of (X → Y)
  z = rpe (fe 𝓤 𝓤₀) r
  a : (𝕋 X → 𝟚) ≃ (X → 𝟚)
  a = totally-separated-reflection'' 𝟚-is-totally-separated
  b : retract (𝕋 X → 𝟚) of (X → 𝟚)
  b = equiv-retract-l a
  d : retract (𝕋 X → 𝟚) of (X → Y)
  d = retracts-compose z b
  e : Π-compact (𝕋 X → 𝟚)
  e = retract-Π-compact d c
  f : is-discrete (𝕋 X)
  f = tscd tts e

\end{code}

In topological models, Π-compactness is the same as topological
compactess in the presence of total separatedness, at least for some
spaces, including the Kleene-Kreisel spaces, which model the simple
types (see the module SimpleTypes). Hence, for example, the
topological space (ℕ∞→𝟚) is not Π-compact because it is countably
discrete, as it is a theorem of topology that discrete to the power
compact is again discrete, which is compact iff it is finite. This
argument is both classical and external.

But here we have that the type (ℕ∞→𝟚) is "not" Π-compact, internally
and constructively.

\begin{code}

[ℕ∞→𝟚]-compact-implies-WLPO : Π-compact (ℕ∞ → 𝟚) → WLPO
[ℕ∞→𝟚]-compact-implies-WLPO c = ℕ∞-discrete-gives-WLPO (tscd (ℕ∞-is-totally-separated (fe 𝓤₀ 𝓤₀)) c)

\end{code}

Closure of compactness under sums (and hence binary products):

\begin{code}

Π-compact-closed-under-Σ : {X : 𝓤 ̇ } {Y : X → 𝓥 ̇ }
                         → Π-compact X → ((x : X) → Π-compact (Y x))
                         → Π-compact (Σ Y)
Π-compact-closed-under-Σ {𝓤} {𝓥} {X} {Y} c d p = g e
 where
  f : ∀ x → decidable (∀ y → p (x , y) ≡ ₁)
  f x = d x (λ y → p (x , y))
  q : X → 𝟚
  q = pr₁ (co-characteristic-function f)
  q₀ : (x : X) → q x ≡ ₀ → ¬ ((y : Y x) → p (x , y) ≡ ₁)
  q₀ x = pr₁(pr₂ (co-characteristic-function f) x)
  q₁ : (x : X) → q x ≡ ₁ → (y : Y x) → p (x , y) ≡ ₁
  q₁ x = pr₂(pr₂ (co-characteristic-function f) x)
  e : decidable (∀ x → q x ≡ ₁)
  e = c q
  g : decidable (∀ x → q x ≡ ₁) → decidable(∀ σ → p σ ≡ ₁)
  g (inl α) = inl h
   where
    h : (σ : Σ Y) → p σ ≡ ₁
    h (x , y) = q₁ x (α x) y
  g (inr u) = inr (contrapositive h u)
   where
    h : ((σ : Σ Y) → p σ ≡ ₁) → (x : X) → q x ≡ ₁
    h β x = different-from-₀-equal-₁ (λ r → q₀ x r (λ y → β (x , y)))

\end{code}

TODO. Consider also other possible closure properties, and
∃-compactness.

We now turn to propositions. A proposition is ∃-compact iff it is
decidable. Regarding the compactness of propositions, we have partial
information for the moment.

\begin{code}

isod : (X : 𝓤 ̇ ) → is-prop X → ∃-compact X → decidable X
isod X isp c = f a
 where
  a : decidable ∥ X × (₀ ≡ ₀) ∥
  a = c (λ x → ₀)

  f : decidable ∥ X × (₀ ≡ ₀) ∥ → decidable X
  f (inl s) = inl (∥∥-rec isp pr₁ s)
  f (inr u) = inr (λ x → u ∣ x , refl ∣)

isod-corollary : {X : 𝓤 ̇ } → ∃-compact X → decidable ∥ X ∥
isod-corollary {𝓤} {X} c = isod ∥ X ∥ ∥∥-is-a-prop
                                      (surjection-∃-compact ∣_∣ pt-is-surjection c)

isdni : {X : 𝓤 ̇ } → ∃-compact X → ¬¬ X → ∥ X ∥
isdni {𝓤} {X} c φ = g (isod-corollary c)
 where
  g : decidable ∥ X ∥ → ∥ X ∥
  g (inl s) = s
  g (inr u) = 𝟘-elim (φ (λ x → u ∣ x ∣))

idso : (X : 𝓤 ̇ ) → is-prop X → decidable X → ∃-compact X
idso X isp d p = g d
 where
  g : decidable X → decidable (∃ \x → p x ≡ ₀)
  g (inl x) = 𝟚-equality-cases b c
   where
    b : p x ≡ ₀ → decidable (∃ \x → p x ≡ ₀)
    b r = inl ∣ x , r ∣

    c : p x ≡ ₁ → decidable (∃ \x → p x ≡ ₀)
    c r = inr (∥∥-rec (𝟘-is-prop) f)
     where
      f : ¬ Σ \y → p y ≡ ₀
      f (y , q) = zero-is-not-one (transport (λ - → p - ≡ ₀) (isp y x) q ⁻¹ ∙ r)

  g (inr u) = inr (∥∥-rec 𝟘-is-prop (λ σ → u(pr₁ σ)))

icdn : (X : 𝓤 ̇ ) → is-prop X → Π-compact X → decidable(¬ X)
icdn X isp c = f a
 where
  a : decidable (X → ₀ ≡ ₁)
  a = c (λ x → ₀)

  f : decidable (X → ₀ ≡ ₁) → decidable (¬ X)
  f (inl u) = inl (zero-is-not-one  ∘ u)
  f (inr φ) = inr λ u → φ (λ x → 𝟘-elim (u x) )

emcdn : (X : 𝓤 ̇ ) → is-prop X → Π-compact(X + ¬ X) → decidable (¬ X)
emcdn X isp c = Cases a l m
 where
  p : X + ¬ X → 𝟚
  p (inl x) = ₀
  p (inr u) = ₁

  a : decidable ((z : X + ¬ X) → p z ≡ ₁)
  a = c p

  l : ((z : X + ¬ X) → p z ≡ ₁) → ¬ X + ¬¬ X
  l α = inl(λ x → 𝟘-elim (zero-is-not-one (α (inl x))))

  α : (u : X → 𝟘) (z : X + ¬ X) → p z ≡ ₁
  α u (inl x) = 𝟘-elim (u x)
  α u (inr v) = refl

  m : ¬((z : X + ¬ X) → p z ≡ ₁) → ¬ X + ¬¬ X
  m φ = inr(λ u → φ(α u))

\end{code}

8th Feb 2018: A pointed detachable subset of any type is a
retract. Hence any detachable (pointed or not) subset of a ∃-compact
type is compact. The first construction should probably go to another
module.

\begin{code}

detachable-subset-retract : {X : 𝓤 ̇ } {A : X → 𝟚}
                          → (Σ \(x : X) → A(x) ≡ ₀)
                          → retract (Σ \(x : X) → A(x) ≡ ₀) of X
detachable-subset-retract {𝓤} {X} {A} (x₀ , e₀) = r , pr₁ , rs
 where
  r : X → Σ \(x : X) → A x ≡ ₀
  r x = 𝟚-equality-cases (λ(e : A x ≡ ₀) → (x , e)) (λ(e : A x ≡ ₁) → (x₀ , e₀))
  rs : (σ : Σ \(x : X) → A x ≡ ₀) → r(pr₁ σ) ≡ σ
  rs (x , e) = w
   where
    s : (b : 𝟚) → b ≡ ₀ → 𝟚-equality-cases (λ(_ : b ≡ ₀) → (x , e))
                                             (λ(_ : b ≡ ₁) → (x₀ , e₀)) ≡ (x , e)
    s ₀ refl = refl
    s ₁ ()
    t : 𝟚-equality-cases (λ(_ : A x ≡ ₀) → x , e) (λ (_ : A x ≡ ₁) → x₀ , e₀) ≡ (x , e)
    t = s (A x) e
    u : (λ e' → x , e') ≡ (λ _ → x , e)
    u = dfunext (fe 𝓤₀ 𝓤) λ e' → ap (λ - → (x , -)) (𝟚-is-set e' e)
    v : r x ≡ 𝟚-equality-cases (λ(_ : A x ≡ ₀) → x , e) (λ (_ : A x ≡ ₁) → x₀ , e₀)
    v = ap (λ - → 𝟚-equality-cases - (λ(_ : A x ≡ ₁) → x₀ , e₀)) u
    w : r x ≡ x , e
    w = v ∙ t

\end{code}

Notice that in the above lemma we need to assume that the detachable
set is pointed. But its use below doesn't, because ∃-compactness
allows us to decide inhabitedness, and ∃-compactness is a proposition.

\begin{code}

detachable-subset-∃-compact : {X : 𝓤 ̇ } (A : X → 𝟚)
                            → ∃-compact X
                            → ∃-compact(Σ \(x : X) → A(x) ≡ ₀)
detachable-subset-∃-compact {𝓤} {X} A c = g (c A)
 where
  g : decidable (∃ \(x : X) → A x ≡ ₀) → ∃-compact(Σ \(x : X) → A(x) ≡ ₀)
  g (inl e) = retract-∃-compact' (∥∥-functor detachable-subset-retract e) c
  g (inr u) = is-empty-∃-compact (contrapositive ∣_∣ u)

\end{code}

For the compact case, the retraction method to prove the last theorem
is not available, but the conclusion holds, with some of the same
ingredients (and with a longer proof (is there a shorter one?)).

\begin{code}

detachable-subset-Π-compact : {X : 𝓤 ̇ } (A : X → 𝟚)
                            → Π-compact X → Π-compact(Σ \(x : X) → A(x) ≡ ₁)
detachable-subset-Π-compact {𝓤} {X} A c q = g (c p)
 where
  p₀ : (x : X) → A x ≡ ₀ → 𝟚
  p₀ x e = ₁
  p₁ : (x : X) → A x ≡ ₁ → 𝟚
  p₁ x e = q (x , e)
  p : X → 𝟚
  p x = 𝟚-equality-cases (p₀ x) (p₁ x)
  p-spec₀ : (x : X) → A x ≡ ₀ → p x ≡ ₁
  p-spec₀ x e = s (A x) e (p₁ x)
   where
    s : (b : 𝟚) → b ≡ ₀ → (f₁ : b ≡ ₁ → 𝟚)
      → 𝟚-equality-cases (λ (_ : b ≡ ₀) → ₁) f₁ ≡ ₁
    s ₀ refl = λ f₁ → refl
    s ₁ ()
  p-spec₁ : (x : X) (e : A x ≡ ₁) → p x ≡ q (x , e)
  p-spec₁ x e = u ∙ t
   where
    y : A x ≡ ₁ → 𝟚
    y _ = q (x , e)
    r : p₁ x ≡ y
    r = (dfunext (fe 𝓤₀ 𝓤₀)) (λ e' → ap (p₁ x) (𝟚-is-set e' e))
    s : (b : 𝟚) → b ≡ ₁
      → 𝟚-equality-cases (λ (_ : b ≡ ₀) → ₁) (λ (_ : b ≡ ₁) → q (x , e)) ≡ q (x , e)
    s ₀ ()
    s ₁ refl = refl
    t : 𝟚-equality-cases (p₀ x) y ≡ q (x , e)
    t = s (A x) e
    u : p x ≡ 𝟚-equality-cases (p₀ x) y
    u = ap (𝟚-equality-cases (p₀ x)) r
  g : decidable ((x : X) → p x ≡ ₁) → decidable ((σ : Σ \(x : X) → A x ≡ ₁) → q σ ≡ ₁)
  g (inl α) = inl h
   where
    h : (σ : Σ \(x : X) → A x ≡ ₁) → q σ ≡ ₁
    h (x , e) = (p-spec₁ x e) ⁻¹ ∙ α x
  g (inr u) = inr(contrapositive h u)
   where
    h : ((σ : Σ \(x : X) → A x ≡ ₁) → q σ ≡ ₁) → (x : X) → p x ≡ ₁
    h β x = 𝟚-equality-cases (p-spec₀ x) (λ e → p-spec₁ x e ∙ β (x , e))

\end{code}

20 Jan 2018.

We now consider a truncated version of pointed compactness (see the
module CompactTypes).

\begin{code}

∃-compact∙ : 𝓤 ̇ → 𝓤 ̇
∃-compact∙ X = (p : X → 𝟚) → ∃ \(x₀ : X) → p x₀ ≡ ₁ → (x : X) → p x ≡ ₁

∃-compactness∙-is-a-prop : {X : 𝓤 ̇ } → is-prop (∃-compact∙ X)
∃-compactness∙-is-a-prop {𝓤} = Π-is-prop (fe 𝓤 𝓤) (λ _ → ∥∥-is-a-prop)

\end{code}

Notice that, in view of the above results, inhabitedness can be
replaced by non-emptiness in the following results:

\begin{code}

iso-i-and-c : {X : 𝓤 ̇ } → ∃-compact∙ X → ∥ X ∥ × ∃-compact X
iso-i-and-c {𝓤} {X} c = (∥∥-functor pr₁ g₁ , λ p → ∥∥-rec (decidability-of-prop-is-prop (fe 𝓤 𝓤₀) ∥∥-is-a-prop) (g₂ p) (c p))
 where
  g₁ : ∥ Σ (λ x₀ → ₀ ≡ ₁ → (x : X) → ₀ ≡ ₁) ∥
  g₁ = c (λ x → ₀)

  g₂ : (p : X → 𝟚) → (Σ \(x₀ : X) → p x₀ ≡ ₁ → (x : X) → p x ≡ ₁) → decidable (∃ \(x : X) → p x ≡ ₀)
  g₂ p (x₀ , φ) = h (𝟚-is-discrete (p x₀) ₁)
   where
    h : decidable(p x₀ ≡ ₁) → decidable (∃ \(x : X) → p x ≡ ₀)
    h (inl r) = inr (∥∥-rec 𝟘-is-prop f)
     where
      f : ¬ Σ \(x : X) → p x ≡ ₀
      f (x , s) = zero-is-not-one (s ⁻¹ ∙ φ r x)
    h (inr u) = inl ∣ x₀ , (different-from-₁-equal-₀ u) ∣

i-and-c-iso : {X : 𝓤 ̇ } → ∥ X ∥ × ∃-compact X → ∃-compact∙ X
i-and-c-iso {𝓤} {X} (t , c) p = ∥∥-rec ∥∥-is-a-prop f t
 where
  f : X → ∃ \(x₀ : X) → p x₀ ≡ ₁ → (x : X) → p x ≡ ₁
  f x₀ = g (𝟚-is-discrete (p x₀) ₀) (c p)
   where
    g : decidable(p x₀ ≡ ₀) → decidable (∃ \(x : X) → p x ≡ ₀) → ∃ \(x₀ : X) → p x₀ ≡ ₁ → (x : X) → p x ≡ ₁
    g (inl r) e = ∣ x₀ , (λ s _ → 𝟘-elim (zero-is-not-one (r ⁻¹ ∙ s))) ∣
    g (inr _) (inl t) = ∥∥-functor h t
     where
      h : (Σ \(x : X) → p x ≡ ₀) → Σ \(x₀ : X) → p x₀ ≡ ₁ → (x : X) → p x ≡ ₁
      h (x , r) = x , λ s _ → 𝟘-elim (zero-is-not-one (r ⁻¹ ∙ s))
    g (inr _) (inr v) = ∣ x₀ , (λ _ → not-exists₀-implies-forall₁ pt p v) ∣

\end{code}

This characterizes the ∃-compact∙ types as those that are ∃-compact
and inhabited. We can also characterize the ∃-compact types as those
that are ∃-compact∙ or empty:

\begin{code}

isoore-is-a-prop : {X : 𝓤 ̇ } → is-prop(∃-compact∙ X + is-empty X)
isoore-is-a-prop {𝓤} {X} = sum-of-contradictory-props
                            ∃-compactness∙-is-a-prop
                              (Π-is-prop (fe 𝓤 𝓤₀) (λ _ → 𝟘-is-prop))
                                 (λ c u → ∥∥-rec 𝟘-is-prop (contrapositive pr₁ u) (c (λ _ → ₀)))

isoore-so : {X : 𝓤 ̇ } → ∃-compact∙ X + is-empty X → ∃-compact X
isoore-so (inl c) = pr₂(iso-i-and-c c)
isoore-so (inr u) = is-empty-∃-compact u

so-isoore : {X : 𝓤 ̇ } → ∃-compact X → ∃-compact∙ X + is-empty X
so-isoore {𝓤} {X} c = g
 where
  h : decidable (∃ \(x : X) → ₀ ≡ ₀) → ∃-compact∙ X + is-empty X
  h (inl t) = inl (i-and-c-iso (∥∥-functor pr₁ t , c))
  h (inr u) = inr (contrapositive (λ x → ∣ x , refl ∣) u)

  g : ∃-compact∙ X + is-empty X
  g = h (c (λ _ → ₀))

\end{code}

8 Feb 2018: A type X is Π-compact iff every map X → 𝟚 has an infimum:

\begin{code}

_has-inf_ : {X : 𝓤 ̇ } → (X → 𝟚) → 𝟚 → 𝓤 ̇
p has-inf n = (∀ x → n ≤₂ p x) × (∀ m → (∀ x → m ≤₂ p x) → m ≤₂ n)

having-inf-is-a-prop : {X : 𝓤 ̇ } (p : X → 𝟚) (n : 𝟚) → is-prop(p has-inf n)
having-inf-is-a-prop {𝓤} {X} p n (f , g) (f' , g') = to-×-≡ r s
 where
  r : f ≡ f'
  r = dfunext (fe 𝓤 𝓤₀) (λ x → dfunext (fe 𝓤₀ 𝓤₀) (λ r → 𝟚-is-set (f x r) (f' x r)))
  s : g ≡ g'
  s = dfunext (fe 𝓤₀ 𝓤) (λ n → dfunext (fe 𝓤 𝓤₀) (λ φ → dfunext (fe 𝓤₀ 𝓤₀) (λ r → 𝟚-is-set (g n φ r) (g' n φ r))))

at-most-one-inf : {X : 𝓤 ̇ } (p : X → 𝟚) → is-prop (Σ \(n : 𝟚) → p has-inf n)
at-most-one-inf p (n , f , g) (n' , f' , g') = to-Σ-≡ (≤₂-anti (g' n f) (g n' f') , having-inf-is-a-prop p n' _ _)

has-infs : 𝓤 ̇ → 𝓤 ̇
has-infs X = ∀(p : X → 𝟚) → Σ \(n : 𝟚) → p has-inf n

having-infs-is-a-prop : {X : 𝓤 ̇ } → is-prop(has-infs X)
having-infs-is-a-prop {𝓤} {X} = Π-is-prop (fe 𝓤 𝓤) at-most-one-inf

Π-compact-has-infs : {X : 𝓤 ̇ } → Π-compact X → has-infs X
Π-compact-has-infs c p = g (c p)
 where
  g : decidable (∀ x → p x ≡ ₁) → Σ \(n : 𝟚) → p has-inf n
  g (inl α) = ₁ , (λ x _ → α x) , λ m _ → ₁-top
  g (inr u) = ₀ , (λ _ → ₀-bottom) , h
   where
    h : (m : 𝟚) → (∀ x → m ≤₂ p x) → m ≤₂ ₀
    h _ φ r = 𝟘-elim (u α)
     where
      α : ∀ x → p x ≡ ₁
      α x = φ x r

has-infs-Π-compact : {X : 𝓤 ̇ } → has-infs X → Π-compact X
has-infs-Π-compact h p = f (h p)
 where
  f : (Σ \(n : 𝟚) → p has-inf n) → decidable (∀ x → p x ≡ ₁)
  f (₀ , _ , h) = inr u
   where
    u : ¬ ∀ x → p x ≡ ₁
    u α = zero-is-not-one (h ₁ (λ x r → α x) refl)
  f (₁ , g , _) = inl α
   where
    α : ∀ x → p x ≡ ₁
    α x = g x refl

\end{code}

TODO. Show equivalence with existence of suprema. Is there a similar
characterization of ∃-compactness?

Implicit application of type-theoretical choice:

\begin{code}

inf : {X : 𝓤 ̇ } → Π-compact X → (X → 𝟚) → 𝟚
inf c p = pr₁(Π-compact-has-infs c p)

inf-property : {X : 𝓤 ̇ } → (c : Π-compact X) (p : X → 𝟚) → p has-inf (inf c p)
inf-property c p = pr₂(Π-compact-has-infs c p)

inf₁ : {X : 𝓤 ̇ } (c : Π-compact X) {p : X → 𝟚}
     → inf c p ≡ ₁ → ∀ x → p x ≡ ₁
inf₁ c {p} r x = pr₁(inf-property c p) x r

inf₁-converse : {X : 𝓤 ̇ } (c : Π-compact X) {p : X → 𝟚}
              → (∀ x → p x ≡ ₁) → inf c p ≡ ₁
inf₁-converse c {p} α = ₁-maximal (h g)
 where
  h : (∀ x → ₁ ≤₂ p x) → ₁ ≤₂ inf c p
  h = pr₂(inf-property c p) ₁
  g : ∀ x → ₁ ≤₂ p x
  g x _ = α x

\end{code}

21 Feb 2018.

It is well known that infima and suprema are characterized as
adjoints. TODO. Link the above development with the following (easy).

In synthetic topology with the dominance 𝟚, a type is called 𝟚-compact
if the map Κ : 𝟚 → (X → 𝟚) has a right adjoint A : (X → 𝟚) → 𝟚, with
respect to the natural ordering of 𝟚 and the pointwise order of the
function type (X → 𝟚), and 𝟚-overt if it has a left-adjoint
E : (X → 𝟚) → 𝟚.

Κ is the usual combinator (written Kappa rather than Kay here):

\begin{code}

Κ : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } → Y → (X → Y)
Κ y x = y

\end{code}

The pointwise order on boolean predicates:

\begin{code}

_≤̇_ : {X : 𝓤 ̇ } → (X → 𝟚) → (X → 𝟚) → 𝓤 ̇
p ≤̇ q = ∀ x → p x ≤₂ q x

\end{code}

We define adjunctions in the two special cases where one of the sides
is Κ with Y=𝟚, for simplicity, rather than in full generality:

\begin{code}

Κ⊣ : {X : 𝓤 ̇ } → ((X → 𝟚) → 𝟚) → 𝓤 ̇
Κ⊣ A = (n : 𝟚) (p : _ → 𝟚) → Κ n ≤̇ p ⇔ n ≤₂ A p

_⊣Κ : {X : 𝓤 ̇ } → ((X → 𝟚) → 𝟚) → 𝓤 ̇
E ⊣Κ = (n : 𝟚) (p : _ → 𝟚) → E p ≤₂ n ⇔ p ≤̇ Κ n

\end{code}

TODO: The types Κ⊣ A and E ⊣Κ are propositions, and so are the types
Σ \A → Κ⊣ A (compactness) and Σ \E → E ⊣Κ (overtness).

Right adjoints to Κ are characterized as follows:

\begin{code}

Κ⊣-charac : {X : 𝓤 ̇ } → (A : (X → 𝟚) → 𝟚)
           → Κ⊣ A ⇔ ((p : X → 𝟚) → A p ≡ ₁ ⇔ p ≡ (λ x → ₁))
Κ⊣-charac {𝓤} {X} A = f , g
 where
  f : Κ⊣ A → (p : X → 𝟚) → A p ≡ ₁ ⇔ p ≡ (λ x → ₁)
  f φ p = f₀ , f₁
   where
    f₀ : A p ≡ ₁ → p ≡ (λ x → ₁)
    f₀ r = dfunext (fe 𝓤 𝓤₀) l₃
     where
      l₀ : ₁ ≤₂ A p → Κ ₁ ≤̇ p
      l₀ = pr₂ (φ ₁ p)
      l₁ : Κ ₁ ≤̇ p
      l₁ = l₀ (λ _ → r)
      l₂ : (x : X) → ₁ ≤₂ p x
      l₂ = l₁
      l₃ : (x : X) → p x ≡ ₁
      l₃ x = l₂ x refl
    f₁ : p ≡ (λ x → ₁) → A p ≡ ₁
    f₁ s = l₀ refl
     where
      l₃ : (x : X) → p x ≡ ₁
      l₃ = happly s
      l₂ : (x : X) → ₁ ≤₂ p x
      l₂ x _ = l₃ x
      l₁ : Κ ₁ ≤̇ p
      l₁ = l₂
      l₀ : ₁ ≤₂ A p
      l₀ = pr₁ (φ ₁ p) l₁
  g : ((p : X → 𝟚) → A p ≡ ₁ ⇔ p ≡ (λ x → ₁)) → Κ⊣ A
  g γ n p = (g₀ n refl , g₁ n refl)
   where
    g₀ : ∀ m → m ≡ n → Κ m ≤̇ p → m ≤₂ A p
    g₀ ₀ r l ()
    g₀ ₁ refl l refl = pr₂ (γ p) l₁
     where
      l₀ : (x : X) → p x ≡ ₁
      l₀ x = l x refl
      l₁ : p ≡ (λ x → ₁)
      l₁ = dfunext (fe 𝓤 𝓤₀) l₀
    g₁ : ∀ m → m ≡ n → m ≤₂ A p → Κ m ≤̇ p
    g₁ ₀ r l x ()
    g₁ ₁ refl l x refl = l₀ x
     where
      l₁ : p ≡ (λ x → ₁)
      l₁ = pr₁ (γ p) (l refl)
      l₀ : (x : X) → p x ≡ ₁
      l₀ = happly l₁

\end{code}

Using this as a lemma, we see that a type is Π-compact in the sense we
defined iff it is compact in the usual sense of synthetic topology for
the dominance 𝟚.

\begin{code}

Π-compact-iff-Κ-has-right-adjoint : {X : 𝓤 ̇ }
                                  → Π-compact X ⇔ (Σ \(A : (X → 𝟚) → 𝟚) → Κ⊣ A)
Π-compact-iff-Κ-has-right-adjoint {𝓤} {X} = (f , g)
 where
  f : Π-compact X → Σ \(A : (X → 𝟚) → 𝟚) → Κ⊣ A
  f c = (A , pr₂ (Κ⊣-charac A) l₁)
   where
    c' : (p : X → 𝟚) → decidable (p ≡ (λ x → ₁))
    c' = Π-compact-gives-Π-compact' c
    l₀ : (p : X → 𝟚) → decidable (p ≡ (λ x → ₁)) → Σ \(n : 𝟚) → n ≡ ₁ ⇔ p ≡ (λ x → ₁)
    l₀ p (inl r) = (₁ , ((λ _ → r) , λ _ → refl))
    l₀ p (inr u) = (₀ , ((λ s → 𝟘-elim (zero-is-not-one s)) , λ r → 𝟘-elim (u r)))
    A : (X → 𝟚) → 𝟚
    A p = pr₁(l₀ p (c' p))
    l₁ : (p : X → 𝟚) → A p ≡ ₁ ⇔ p ≡ (λ x → ₁)
    l₁ p = pr₂(l₀ p (c' p))
  g : ((Σ \(A : (X → 𝟚) → 𝟚) → Κ⊣ A)) → Π-compact X
  g (A , φ) = Π-compact'-gives-Π-compact c'
   where
    l₁ : (p : X → 𝟚) → A p ≡ ₁ ⇔ p ≡ (λ x → ₁)
    l₁ = pr₁ (Κ⊣-charac A) φ
    l₀ : (p : X → 𝟚) → decidable(A p ≡ ₁) → decidable (p ≡ (λ x → ₁))
    l₀ p (inl r) = inl (pr₁ (l₁ p) r)
    l₀ p (inr u) = inr (contrapositive (pr₂ (l₁ p)) u)
    c' : (p : X → 𝟚) → decidable (p ≡ (λ x → ₁))
    c' p = l₀ p (𝟚-is-discrete (A p) ₁)

\end{code}

Next we show that κ has a right adjoint iff it has a left adjoint,
namely its De Morgan dual, which exists because 𝟚 is a boolean algebra
and hence so is the type (X → 𝟚) with the pointwise operations.

\begin{code}

𝟚-DeMorgan-dual : {X : 𝓤 ̇ } → ((X → 𝟚) → 𝟚) → ((X → 𝟚) → 𝟚)
𝟚-DeMorgan-dual φ = λ p → complement(φ(λ x → complement(p x)))

𝟚-DeMorgan-dual-involutive :{X : 𝓤 ̇ } → (φ : (X → 𝟚) → 𝟚)
                           → 𝟚-DeMorgan-dual(𝟚-DeMorgan-dual φ) ≡ φ
𝟚-DeMorgan-dual-involutive {𝓤} φ = dfunext (fe 𝓤 𝓤₀) h
 where
  f : ∀ p → complement (complement (φ (λ x → complement (complement (p x)))))
          ≡ φ (λ x → complement (complement (p x)))
  f p = complement-involutive (φ (λ x → complement (complement (p x))))

  g : ∀ p → φ (λ x → complement (complement (p x))) ≡ φ p
  g p = ap φ (dfunext (fe 𝓤 𝓤₀) (λ x → complement-involutive (p x)))

  h : ∀ p → 𝟚-DeMorgan-dual(𝟚-DeMorgan-dual φ) p ≡ φ p
  h p = f p ∙ g p

Π-compact-is-𝟚-overt : {X : 𝓤 ̇ } → (A : (X → 𝟚) → 𝟚)
                      → Κ⊣ A → (𝟚-DeMorgan-dual A) ⊣Κ
Π-compact-is-𝟚-overt {𝓤} {X} A = f
 where
  E : (X → 𝟚) → 𝟚
  E = 𝟚-DeMorgan-dual A
  f : Κ⊣ A → E ⊣Κ
  f φ = γ
   where
     γ : (n : 𝟚) (p : X → 𝟚) → (E p ≤₂ n) ⇔ (p ≤̇ Κ n)
     γ n p = (γ₀ , γ₁ )
      where
       γ₀ : E p ≤₂ n → p ≤̇ Κ n
       γ₀ l = m₃
        where
         m₀ : complement n ≤₂ A (λ x → complement (p x))
         m₀ = complement-left l
         m₁ : Κ (complement n) ≤̇ (λ x → complement (p x))
         m₁ = pr₂ (φ (complement n) (λ x → complement (p x))) m₀
         m₂ : (x : X) → complement n ≤₂ complement (p x)
         m₂ = m₁
         m₃ : (x : X) → p x ≤₂ n
         m₃ x = complement-both-left (m₂ x)

       γ₁ : p ≤̇ Κ n → E p ≤₂ n
       γ₁ l = complement-left m₀
        where
         m₃ : (x : X) → p x ≤₂ n
         m₃ = l
         m₂ : (x : X) → complement n ≤₂ complement (p x)
         m₂ x = complement-both-right (m₃ x)
         m₁ : Κ (complement n) ≤̇ (λ x → complement (p x))
         m₁ = m₂
         m₀ : complement n ≤₂ A (λ x → complement (p x))
         m₀ = pr₁ (φ (complement n) (λ x → complement (p x))) m₁

𝟚-overt-is-Π-compact : {X : 𝓤 ̇ } → (E : (X → 𝟚) → 𝟚)
                     → E ⊣Κ → Κ⊣ (𝟚-DeMorgan-dual E)
𝟚-overt-is-Π-compact {𝓤} {X} E = g
 where
  A : (X → 𝟚) → 𝟚
  A = 𝟚-DeMorgan-dual E
  g : E ⊣Κ → Κ⊣ A
  g γ = φ
   where
     φ : (n : 𝟚) (p : X → 𝟚) → Κ n ≤̇ p ⇔ n ≤₂ A p
     φ n p = (φ₀ , φ₁ )
      where
       φ₀ : Κ n ≤̇ p → n ≤₂ A p
       φ₀ l = complement-right m₀
        where
         m₃ : (x : X) → n ≤₂ p x
         m₃ = l
         m₂ : (x : X) → complement (p x) ≤₂ complement n
         m₂ x = complement-both-right (m₃ x)
         m₁ : (λ x → complement (p x)) ≤̇ Κ (complement n)
         m₁ = m₂
         m₀ : E (λ x → complement (p x)) ≤₂ complement n
         m₀ = pr₂ (γ (complement n) (λ x → complement (p x))) m₂

       φ₁ : n ≤₂ A p → Κ n ≤̇ p
       φ₁ l = m₃
        where
         m₀ : E (λ x → complement (p x)) ≤₂ complement n
         m₀ = complement-right l
         m₁ : (λ x → complement (p x)) ≤̇ Κ (complement n)
         m₁ = pr₁ (γ (complement n) (λ x → complement (p x))) m₀
         m₂ : (x : X) → complement (p x) ≤₂ complement n
         m₂ = m₁
         m₃ : (x : X) → n ≤₂ p x
         m₃ x = complement-both-left (m₂ x)

\end{code}

We have the following corollaries:

\begin{code}

Π-compact-iff-𝟚-overt : {X : 𝓤 ̇ }
                      → (Σ \(A : (X → 𝟚) → 𝟚) → Κ⊣ A) ⇔ (Σ \(E : (X → 𝟚) → 𝟚) → E ⊣Κ)
Π-compact-iff-𝟚-overt {𝓤} {X} = (f , g)
 where
  f : (Σ \(A : (X → 𝟚) → 𝟚) → Κ⊣ A) → (Σ \(E : (X → 𝟚) → 𝟚) → E ⊣Κ)
  f (A , φ) = (𝟚-DeMorgan-dual A , Π-compact-is-𝟚-overt A φ)

  g : (Σ \(E : (X → 𝟚) → 𝟚) → E ⊣Κ) → (Σ \(A : (X → 𝟚) → 𝟚) → Κ⊣ A)
  g (E , γ) = (𝟚-DeMorgan-dual E , 𝟚-overt-is-Π-compact E γ)

\end{code}

In this corollary we record explicitly that a type is Π-compact iff it
is 𝟚-overt:

\begin{code}

Π-compact-iff-Κ-has-left-adjoint : {X : 𝓤 ̇ }
                                 → Π-compact X ⇔ (Σ \(E : (X → 𝟚) → 𝟚) → E ⊣Κ)
Π-compact-iff-Κ-has-left-adjoint {𝓤} {X} = (f , g)
 where
  f : Π-compact X → (Σ \(E : (X → 𝟚) → 𝟚) → E ⊣Κ)
  f c = pr₁ Π-compact-iff-𝟚-overt (pr₁ Π-compact-iff-Κ-has-right-adjoint c)

  g : (Σ \(E : (X → 𝟚) → 𝟚) → E ⊣Κ) → Π-compact X
  g o = pr₂ Π-compact-iff-Κ-has-right-adjoint (pr₂ Π-compact-iff-𝟚-overt o)

\end{code}

TODO. We get as a corollary that

      E ⊣Κ ⇔ ((p : X → 𝟚) → E p ≡ ₀ ⇔ p ≡ (λ x → ₀)).

TODO. Find the appropriate place in this file to remark that decidable
propositions are closed under Π-compact/overt meets and joins. And
then clopen sets (or 𝟚-open sets, or complemented subsets) are closed
under Π-compact/over unions and intersections.

20 Feb 2018. In classical topology, a space X is compact iff the
projection A × X → A is a closed map for every space A, meaning that
the image of every closed set is closed. In our case, because of the
use of decidable truth-values in the definition of Π-compactness, the
appropriate notion is that of clopen map, that is, a map that sends
clopen sets to clopen sets. As in our setup, clopen sets correspond to
decidable subsets, or sets with 𝟚-valued characteristic functions. In
our case, the clopeness of the projections characterize the notion of
∃-compactness, which is stronger than compactness.

There is a certain asymmetry in the following definition, in that the
input decidable predicate (or clopen subtype) is given as a 𝟚-valued
function, whereas instead of saying that the image predicate factors
through the embedding 𝟚 of into the type of truth values, we say that
it has decidable truth-values, which is equivalent. Such an asymmetry
is already present in our formulation of the notion of compactness.

We have defined image with lower case in the module UF. We now need
Images with upper case:

\begin{code}

Image : {X : 𝓤 ̇ } {Y : 𝓥 ̇ }
     → (X → Y) → (X → 𝓦 ̇ ) → (Y → 𝓤 ⊔ 𝓥 ⊔ 𝓦 ̇ )
Image f A = λ y → ∃ \x → A x × (f x ≡ y)

is-clopen-map : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } → (X → Y) → 𝓤 ⊔ 𝓥 ̇
is-clopen-map {𝓤} {𝓥} {X} {Y} f = (p : X → 𝟚) (y : Y)
                                → decidable (Image f (λ x → p x ≡ ₀) y)

being-clopen-map-is-a-prop : {X : 𝓤 ̇ } {Y : 𝓥 ̇ } → FunExt
                           → (f : X → Y) → is-prop(is-clopen-map f)
being-clopen-map-is-a-prop {𝓤} {𝓥} fe f =
 Π-is-prop (fe 𝓤 (𝓤 ⊔ 𝓥))
   (λ p → Π-is-prop (fe 𝓥 (𝓤 ⊔ 𝓥))
            (λ y → decidability-of-prop-is-prop (fe (𝓤 ⊔ 𝓥) 𝓤₀) ∥∥-is-a-prop))

fst : (A : 𝓤 ̇ ) (X : 𝓥 ̇ ) → A × X → A
fst _ _ = pr₁

∃-compact-clopen-projections : (X : 𝓤 ̇ )
                             → ∃-compact X
                             → (∀ {𝓥} (A : 𝓥 ̇ ) → is-clopen-map(fst A X))
∃-compact-clopen-projections X c A p a = g (c (λ x → p (a , x)))
 where
  g : decidable (∃ \(x : X) → p (a , x) ≡ ₀)
    → decidable (∃ \(z : A × X) → (p z ≡ ₀) × (pr₁ z ≡ a))
  g (inl e) = inl ((∥∥-functor h) e)
   where
    h : (Σ \(x : X) → p (a , x) ≡ ₀) → Σ \(z : A × X) → (p z ≡ ₀) × (pr₁ z ≡ a)
    h (x , r) =  (a , x) , (r , refl)
  g (inr u) = inr (contrapositive (∥∥-functor h) u)
   where
    h : (Σ \(z : A × X) → (p z ≡ ₀) × (pr₁ z ≡ a)) → Σ \(x : X) → p (a , x) ≡ ₀
    h ((a' , x) , (r , s)) = x , transport (λ - → p (- , x) ≡ ₀) s r

clopen-projections-∃-compact : ∀ {𝓤 𝓦} (X : 𝓤 ̇ )
                             → (∀ {𝓥} (A : 𝓥 ̇ ) → is-clopen-map(fst A X))
                             → ∃-compact X
clopen-projections-∃-compact {𝓤} {𝓦} X κ p = g (κ 𝟙 (λ z → p(pr₂ z)) *)
 where
  g : decidable (∃ \(z : 𝟙 {𝓦} × X) → (p (pr₂ z) ≡ ₀) × (pr₁ z ≡ *))
    → decidable (∃ \(x : X) → p x ≡ ₀)
  g (inl e) = inl (∥∥-functor h e)
   where
    h : (Σ \(z : 𝟙 × X) → (p (pr₂ z) ≡ ₀) × (pr₁ z ≡ *)) → Σ \(x : X) → p x ≡ ₀
    h ((* , x) , r , _) = x , r
  g (inr u) = inr(contrapositive (∥∥-functor h) u)
   where
    h : (Σ \(x : X) → p x ≡ ₀) → Σ \(z : 𝟙 × X) → (p (pr₂ z) ≡ ₀) × (pr₁ z ≡ *)
    h (x , r) = (* , x) , (r , refl)


\end{code}

TODO.

* Consider 𝟚-perfect maps.

* ∃-compactness: attainability of minima. Existence of potential
  maxima.

* Relation of Π-compactness with finiteness and discreteness.

* Non-classical cotaboos Every Π-compact subtype of ℕ is finite. Every
  Π-compact subtype of a discrete type is finite. What are the
  cotaboos necessary (and sufficient) to prove that the type of
  decidable subsingletons of ℕ∞→ℕ is Π-compact?  Continuity principles
  are enough.

* 𝟚-subspace: e:X→Y such that every clopen X→𝟚 extends to some clopen
  Y→𝟚 (formulated with Σ and ∃). Or to a largest such clopen, or a
  smallest such clopen (right and left adjoints to the restriction map
  (Y→𝟚)→(X→𝟚) that maps v to v ∘ e and could be written e ⁻¹[ v ].  A
  𝟚-subspace-embedding of totally separated types should be a
  (homotopy) embedding, but not conversely (find a counter-example).

* 𝟚-injective types (injectives wrt to 𝟚-subspace-embeddigs). They
  should be the retracts of powers of 𝟚. Try to characterize them
  "intrinsically".

* Relation of 𝟚-subspaces with Π-compact subtypes.

* 𝟚-Hofmann-Mislove theorem: clopen filters of clopens should
  correspond to Π-compact (𝟚-saturated) 𝟚-subspaces. Are cotaboos
  needed for this?

* Which results here depend on the particular dominance 𝟚, and which
  ones generalize to any dominance, or to any "suitable" dominance? In
  particular, it is of interest to generalize this to "Sierpinki like"
  dominances. And what is "Sierpinski like" in precise (internal)
  terms? This should be formulated in terms of cotaboos.
