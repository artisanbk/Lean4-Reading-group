/- Copyright (c) 2023 Heather Macbeth. All rights reserved. -/
import Mathlib.Tactic.Ring

/-! In this file we let `ring` silently operate as `ring_nf` (the recursive normalization form of
`ring`) when (1) it is used in conv mode, or (2) it is used terminally.  We also make it fail for
nonterminal use. -/

macro_rules | `(conv | ring) => `(conv | ring_nf)
-- Written with `macro_rules` against the existing syntax rather than as a fresh `macro`.
-- Mathlib now declares `ring` as `macro (name := ring) "ring" : tactic`, and a second parser of
-- the same shape for the same token leaves the two ambiguous, which surfaces as `unknown tactic`.
macro_rules | `(tactic | ring) => `(tactic | first | (ring_nf; done) | ring1)
