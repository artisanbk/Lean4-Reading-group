import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.IntervalCases
import Mathlib.Tactic.Set
import Mathlib.Tactic.Push
import Library.Config.Constructor
import Library.Config.Contradiction
import Library.Config.ExistsDelaborator
import Library.Config.Initialize
import Library.Config.Ring
import Library.Config.Set
import Library.Config.Use
import Library.Theory.Comparison
import Library.Theory.Parity
import Library.Theory.Prime
import Library.Tactic.Addarith
import Library.Tactic.Cancel
import Library.Tactic.Extra.Basic
import Library.Tactic.Induction
import Library.Tactic.Numbers.Basic
import Library.Tactic.Obtain
import Library.Tactic.TruthTable

notation3 (prettyPrint := false) "forall_sufficiently_large "(...)", "r:(scoped P => ∃ C, ∀ x ≥ C, P x) => r

/-! ### `push_neg`

Mathlib deprecated the `push_neg` tactic in favour of `push Not`, and removed the `#push_neg`
command in favour of `#push Not => e`.  *The Mechanics of Proof* teaches the `push_neg` spelling
throughout chapter 5, so we keep it available here.  Both are exact aliases rather than weakened
stand-ins.  The tactic is verbatim the implementation Mathlib recommends in its own deprecation
message for projects that want to keep the name, and `#push_neg e` is by definition
`#push Not => e`.
-/

open Lean.Parser.Tactic in
macro "push_neg" cfg:optConfig loc:(location)? : tactic =>
  `(tactic| push $cfg:optConfig Not $[$loc]?)

macro "#push_neg " e:term : command => `(command| #push Not => $e)

macro "linarith" Mathlib.Tactic.linarithArgsRest : tactic => `(tactic | fail "linarith tactic disabled")
macro "nlinarith" Mathlib.Tactic.linarithArgsRest : tactic => `(tactic | fail "nlinarith tactic disabled")
macro "linarith!" Mathlib.Tactic.linarithArgsRest : tactic => `(tactic | fail "linarith! tactic disabled")
macro "nlinarith!" Mathlib.Tactic.linarithArgsRest : tactic => `(tactic | fail "nlinarith! tactic disabled")
macro "polyrith" : tactic => `(tactic | fail "polyrith tactic disabled")
macro "decide" : tactic => `(tactic | fail "decide tactic disabled")
macro "aesop" : tactic => `(tactic | fail "aesop tactic disabled")
macro "tauto" : tactic => `(tactic | fail "tauto tactic disabled")

open Lean.Parser.Tactic in
macro "simp"  (&" only")?  (" [" withoutPosition((simpStar <|> simpErase <|> simpLemma),*) "]")?
  (location)? : tactic => `(tactic | fail "simp tactic disabled")

/--
Configure the environment with the right options and attributes
for the book *The Mechanics of Proof*.

Tries to perform essentially the following:

```
set_option push_neg.use_distrib true
set_option linter.deprecated false

attribute [-simp] ne_eq
attribute [-ext] Prod.ext
attribute [-instance] Int.instDivInt_1 Int.instDivInt Nat.instDivNat
attribute [-norm_num] Mathlib.Meta.NormNum.evalNatDvd
  Mathlib.Meta.NormNum.evalIntDvd
```
-/
elab "math2001_init" : command => do
  trySetOptions #[
    ⟨`push_neg.use_distrib, true⟩,
    -- `Reflexive`/`Symmetric`/`AntiSymmetric`/`Transitive` are deprecated upstream but still
    -- work, and chapter 10 is built on them.  They are plain definitions, which is what makes
    -- `dsimp [Reflexive]` the method of that chapter.  Their replacements (`Std.Refl`,
    -- `IsTrans`, ...) are type classes, which cannot be unfolded that way, so we silence the
    -- linter rather than diverge from the text.  This reaches the course files only, since
    -- `Library` never calls `math2001_init`.  PORTING.md has the full reasoning.
    ⟨`linter.deprecated, false⟩
  ]
  tryEraseAttrs #[
    ⟨`simp, #[`ne_eq]⟩,
    ⟨`ext, #[`Prod.ext]⟩,
    ⟨`instance, #[`Int.instDivInt_1,`Int.instDivInt, `Nat.instDivNat]⟩,
    ⟨`norm_num, #[`Mathlib.Meta.NormNum.evalNatDvd, `Mathlib.Meta.NormNum.evalIntDvd]⟩
  ]
