# Invariants

This document is the preservation contract for symbol-related behavior in
[`config/adv360.keymap`](config/adv360.keymap). It intentionally does not duplicate the full layout;
the keymap remains the source of truth for individual bindings.

## General ergonomic invariants

These rules are the first filter for key-placement proposals. Abstract symmetry, completeness, or
mnemonic neatness does not outweigh them. Any deliberate exception must name its ergonomic cost.

1. **The home row is ideal; the number row is a last resort.**
   Prefer a home-row position whenever the competing bindings are otherwise comparable. Do not
   present moving a frequent binding to the number row as an ergonomic improvement.

2. **Strength and dexterity decrease toward the outside of the hand.**
   All else being equal, work becomes less suitable as it moves from the stronger inner fingers
   toward the ring finger and pinky. A visually tidy outward placement is not ergonomically neutral.

3. **The Advantage360 mitigates some outer-pinky reach costs; it does not erase them.**
   Its large, curved outer-pinky keys are easier to reach than ordinary outer keys. They are still a
   long way from the pinky's home-row position and must not be treated as home-row-equivalent.

4. **Simultaneous holds carry cumulative cost.**
   A fixed or mnemonic chord may be easier to remember, but that does not make it physically free.
   Prefer fewer simultaneous holds when reach and sequencing costs remain comparable.

## Reach and hold constraints

| Constraint                                                                                                | Design consequence                                                                                                    |
| --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| The right bottom keywell row is easy to reach and sits inline with the upper thumb-cluster keys.          | It carries `: ^ $ _`.                                                                                                 |
| The inner edge of either keywell is a rough reach.                                                        | Avoid using the extra inner keys unless a binding is particularly infrequent.                                         |
| The first key immediately beyond the right and left pinkies are usable; the farther outer keys are rough. | Do not move frequent symbols outward merely to improve an abstract grid.                                              |
| Index-finger same-finger sequences are acceptable when they don't scissor.                                | The current `</` and `/=` paths are acceptable; `</` is preferable to its former pinky-involving path.                |

## Delimiter selection invariants

| Pair | Preferred selector | Compatibility selector |
| ---- | ------------------ | ---------------------- |
| `()` | None               | —                      |
| `{}` | Shift              | —                      |
| `[]` | Ctrl               | —                      |
| `<>` | Left Alt           | —                      |

Left Alt is the single-finger angle selector. It must be masked while emitting either angle and
while rolling through the protected punctuation family below. Right Alt remains an ordinary host
modifier.

## Roll and sequence invariants

| Sequence or family     |
| ---------------------- |
| `:=`, `\|=`, `&=`      |
| `!=`, `?=`             |
| `=>`, `>=`, `<=`       |
| `+=`, `-=`, `*=`, `/=` |
| `</`                   |
| `/*`, `*/`             |
| `);`                   |
| `<-`, `->`             |
| `./`, `/.`             |
| `~/.`                  |

## Pair and grouping invariants

| Pair or group | Notes                                                          |
| ------------- | -------------------------------------------------------------- |
| `\|` `&`      | Adjacent logical and shell operators on the left home row.      |
| `*` `#`       | Paired Neovim word-search motions.                             |
| `^` `$`       | `^$` stays adjacent for Neovim line motions and regex anchors. |

## Other binding invariants

- Keep Base punctuation available through transparent Sym fallthrough unless the same physical key
  intentionally promotes its shifted partner (`.` to `!`, `,` to `?`, and `'` to `"`) or masks an
  active delimiter selector.
- Do not duplicate a Base key at a different physical position on Sym.
- Ctrl-B has dedicated bindings on both Base outer lower keys and remains available through
  transparent Sym fallthrough.
- Hold the Base layer's top-right key to reach the Mod layer's maintenance bindings.

## Handoff invariants

These families previously forced a bounce between Shift and Sym. Their current same-layer or
hold-compatible paths are gains that must be preserved.

| Family                    |
| ------------------------- |
| `("…")`, `")`             |
| `!(`, `+)`                |
| `(?`, `(?:`, `(?=`, `(?!` |
| `$?`, `$!`, `#!`          |
| `![`                      |
| `:%s`, `!~`               |

## Modifier-proof punctuation

The delimiter stack deliberately leaves selector keys held during some sequences. These bindings
must emit literal punctuation instead of leaking the active selector.

| Key            | Plain   | Shift         | Ctrl         | Shift+Ctrl | Left Alt on Sym      | Purpose                                                                                            |
| -------------- | ------: | ------------: | ------------ | ---------: | -------------------: | -------------------------------------------------------------------------------------------------- |
| `=`            |     `=` |           `=` | `Ctrl+=`     |        `=` |                  `=` | Protect `:=`, `!=`, `?=`, `<=`, `>=`, and other equality endings from becoming `+`.                |
| `/`            |     `/` |           `\` | `Ctrl+/`     |        `/` |                  `/` | Retain the normal `/\` pair while keeping angle/slash sequences literal under a delimiter hold.    |
| Combined `-/+` | `-`; Sym gives `+` | `+` | `Ctrl+-` | `Ctrl++` | `-`; Shift gives `+` | Promote an unmodified Sym press to `+` while retaining Base semantics for every held modifier. |
| Space tap      | `Space` | `Shift+Space` | `Ctrl+Space` |    `Space` |              `Space` | Keep trailing space literal; Right Alt remains available for ordinary `Alt+Space`.                 |

## Trainer exercise briefs

These briefs are the authored source for Advantage360-specific Trainer exercises. An LLM consumes
this section and creates or updates one named exercise file per brief in the Trainer project. Trainer
does not parse this document at runtime.

- Treat each exercise ID as stable. Rename or remove one only as a deliberate curriculum migration.
- Preserve the exact practice material and required technique. The live keymap may be inspected to
  explain the physical route, but it must not silently redefine the exercise.
- Use ten consecutive repetitions per sequence unless a brief says otherwise. Keep related sequences
  visually grouped rather than shuffling individual repetitions together.
- When identical text can be produced by another route, the prompt and hint must explicitly require
  the selector, hold, chord, or fallthrough named here. Emitted text alone cannot prove the route.
- Keep all setup, fixtures, evaluation, and exercise-specific progression in the named exercise file.
  Shared Trainer helpers may provide mechanics, but must not become another curriculum manifest.

### `typing.invariants.delimiter-selectors`

- **Practice:** `()`, `{}`, `[]`, `<>`.
- **Required technique:** plain parentheses, Shift-selected braces, Ctrl-selected brackets, and
  Left-Alt-selected angles. Retain the selector through both characters of each pair.
- **Purpose:** make the preferred delimiter stack fluent without teaching placement as an invariant.

### `typing.invariants.equality-endings`

- **Practice:** `:=`, `|=`, `&=`, `!=`, `?=`, `=>`, `>=`, `<=`, `==`.
- **Required technique:** preserve the initiating hold or roll through the literal `=`. Do not release
  and reacquire modifiers merely to avoid the protected equals behavior.
- **Purpose:** preserve the equality family and verify that held selectors do not turn `=` into `+`.

### `typing.invariants.assignment-operators`

- **Practice:** `+=`, `-=`, `*=`, `/=`.
- **Required technique:** use plain `-` and left-thumb/Sym-selected `+` at the combined operator
  position, plus the accepted `/=` index-finger path. Shift remains an alternate route to `+`.
- **Purpose:** retain direct assignment rolls without reintroducing Shift/Sym handoffs.

### `typing.invariants.slash-rolls`

- **Practice:** `</`, `/*`, `*/`, `./`, `/.`, `~/.`, `/\`.
- **Required technique:** keep `/` literal under any active delimiter selector; use shifted slash only
  for the backslash in `/\`.
- **Purpose:** preserve path, comment, and slash/backslash families, including the accepted `</`
  same-finger sequence.

### `typing.invariants.arrows-and-closer`

- **Practice:** `<-`, `->`, `);`.
- **Required technique:** type each as one uninterrupted roll using the preferred selectors.
- **Purpose:** protect the arrow directions and the high-frequency closer roll.

### `typing.invariants.grouped-pairs`

- **Practice:** `|&`, `&|`, `*#`, `^$`.
- **Required technique:** use the adjacent left-home logical operators and the paired Neovim motion
  keys at their canonical positions.
- **Purpose:** exercise both directions of the logical pair plus the search-motion and line-anchor
  groupings.

### `typing.invariants.handoffs`

- **Practice:** `("text")`, `")`, `!(`, `+)`, `(?`, `(?:`, `(?=`, `(?!`, `$?`, `$!`, `#!`, `![`, `:%s`,
  `!~`.
- **Required technique:** keep each sequence on its hold-compatible path. Do not bounce between Shift
  and Sym when the invariant provides a continuous route.
- **Purpose:** retain the handoff improvements that motivated the symbol-layer design.

### `typing.invariants.angle-continuations`

- **Practice:** `<>`, `</`, `<-`, `->`, `<=`, `>=`, `+>`, and an opening `<` followed by `Space`.
- **Required technique:** use Left Alt for angles and keep it held through `/`, `=`, `-`, `+`, or
  trailing Space where the sequence permits. Use Shift on the combined operator key for `+>` without
  releasing Left Alt. The continuation must remain literal while the selector is active.
- **Purpose:** exercise the modifier masking around the preferred angle selector rather than only
  producing isolated `<` and `>` characters.

### `typing.invariants.modifier-proof-closers`

- **Practice:** `+}`, `+>`.
- **Required technique:** retain Shift through the combined operator key and brace closer for `+}`;
  retain Left Alt and Shift through the combined operator key and angle closer for `+>`.
- **Purpose:** verify Shift-selected plus under the delimiter selectors that can remain held.

### `typing.invariants.modifier-proof-matrix`

- **Practice:** `:=`, `!=`, `?=`, `<=`, `>=`, `/\`, `</`, `<-`, `->`, `+>`, and an opening `<`
  followed by `Space`.
- **Required technique:** keep the initiating selector held through `=`, `/`, `-`, `+`, or trailing
  Space. Use the printable representative for each protected behavior rather than releasing modifiers
  to obtain the target text.
- **Purpose:** exercise every printable family in the modifier-proof punctuation matrix. `Ctrl+=`,
  `Ctrl+/`, `Shift+Space`, `Ctrl+Space`, and ordinary Right-Alt+Space remain host-shortcut verification,
  not printable Trainer targets.

### `typing.invariants.sym-fallthrough-punctuation`

- **Practice:** `~` and grave (`` ` ``).
- **Required technique:** keep Sym held and use each punctuation key at its Base physical position.
  Do not release Sym to obtain the target character.
- **Purpose:** preserve Base punctuation through transparent Sym fallthrough after excluding the
  documented shifted-partner promotions and delimiter-selector masks. If the live keymap contains any
  other override, keep the authored target and expose the divergence during practice.

### `nvim.invariants.sym-ctrl-b-fallthrough`

- **Practice:** move one page toward the top from the bottom of a buffer.
- **Required technique:** keep Sym held and use either dedicated outer-lower Ctrl-B binding once.
- **Evaluation:** buffer contents remain unchanged and the cursor lands at least one page above its
  starting position.
- **Purpose:** exercise transparent Sym fallthrough for a non-printable binding.

## Accepted tradeoffs

- `</` and `/=` use index-finger SFBs. Both are comfortable in practice, and `</` is easier than the
  former path involving the pinky.
- `\|` and `&` are adjacent left-home taps rather than a Shift-selected pair.
- `_` uses the home-index `D` position; the inner-index `W` position remains transparent.
- `-` and `+` share a combined position. Shift or the left-thumb Sym hold selects `+`; Left Alt while
  Sym is held restores literal `-`. Left Alt remains masked for angle continuations; literal minus
  while a Shift or Ctrl delimiter selector remains held is not preserved.
- Left `Alt+Space` is reserved for a literal trailing Space after an angle; use Right Alt for an
  ordinary `Alt+Space` shortcut.

The accepted grouping changes above bought direct Sym access, eliminated the known Shift/Sym
handoffs, and added the `./`, `/.`, and `~/.` family.
