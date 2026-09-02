import Lake
open Lake DSL

package math2001 where
  moreServerArgs := #[
    "-Dlinter.unusedVariables=false", -- ignores unused variables
    "-DquotPrecheck=false",
    "-DwarningAsError=false",
    "-Dpp.unicode.fun=true"  -- pretty-prints `fun a ↦ b`
  ]

lean_lib Library

@[default_target]
lean_lib Math2001 where
  globs := #[.submodules `Math2001]
  moreLeanArgs := #[
    "-Dlinter.unusedVariables=false", -- ignores unused variables
    "-DquotPrecheck=false",
    "-DwarningAsError=false",
    "-Dpp.unicode.fun=true"  -- pretty-prints `fun a ↦ b`
  ]

/-
want also
"-Dpush_neg.use_distrib=true", -- negates ¬(P ∧ Q) to (¬ P ∨ ¬ Q)
but currently only Lean core options can be set in lakefile
-/

require mathlib from git "https://github.com/leanprover-community/mathlib4" @ s!"v{Lean.versionString}"

-- Duper backs the `exhaust` tactic (see `Library/Tactic/Exhaust.lean`), used in
-- chapters 8-10. It has no v4.33.1 tag, but 4.33.1 is only a kernel patch over
-- 4.33.0, so the v4.33.0 tag builds fine against this toolchain.
require Duper from git "https://github.com/leanprover-community/duper" @ "v4.33.0"

-- The Gradescope autograder is not wired up in this fork. The `import AutograderLib`
-- lines and `@[autograded n]` attributes in Math2001/Homework are commented out
-- rather than deleted, so re-enabling it means restoring this require and
-- uncommenting those.
-- require autograder from git "https://github.com/robertylewis/lean4-autograder-main" @ "..."
