# Keymap Invariants

This document is the preservation contract for symbol-related behavior in
[`config/adv360.keymap`](config/adv360.keymap). It intentionally does not duplicate the full layout;
the keymap remains the source of truth for individual bindings.

## Reach and hold constraints

| Constraint                                                                                                | Design consequence                                                                                                    |
| --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| Sym is held with the left thumb.                                                                          | Left-hand symbols stay on the home row: `\| & ; _` on `S N D W`; `R` remains transparent.                             |
| The right bottom keywell row is easy to reach and sits inline with the upper thumb-cluster keys.          | It carries `% : ^ $`.                                                                                                 |
| The inner edge of either keywell is a rough reach.                                                        | Avoid using the extra inner keys unless a binding is particularly infrequent.                                         |
| The first key immediately beyond the right and left pinkies are usable; the farther outer keys are rough. | Do not move frequent symbols outward merely to improve an abstract grid.                                              |
| Index-finger same-finger sequences are acceptable when they don't scissor.                                | The current `</` and `/=` paths are acceptable; `</` is preferable to its former pinky-involving path.                |

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
  intentionally promotes its shifted partner (`.` to `!`, `,` to `?`, and `'` to `"`).
- Do not duplicate a Base key at a different physical position on Sym.
- Ctrl-B has dedicated bindings on both Base outer lower keys and remains available through
  transparent Sym fallthrough.
- The Mod layer is intentionally unreachable from Base; its maintenance bindings are parked rather
  than active.

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

The delimiter stack deliberately leaves Shift and Ctrl held during some sequences. These bindings
must emit literal punctuation under those modifiers instead of their ordinary shifted forms.

| Key           | Plain | Shift | Ctrl     | Shift+Ctrl | Purpose                                                                                                |
| ------------- | ----: | ----: | -------- | ---------: | ------------------------------------------------------------------------------------------------------ |
| `=`           |   `=` |   `=` | `Ctrl+=` |        `=` | Protect `:=`, `!=`, `?=`, `<=`, `>=`, and other equality endings from becoming `+`.                    |
| `/`           |   `/` |   `\` | `Ctrl+/` |        `/` | Retain the normal `/\` pair while keeping angle/slash sequences literal under the full delimiter hold. |
| Dedicated `-` |   `-` |   `-` | `-`      |        `-` | Keep minus literal when delimiter modifiers are retained.                                              |
| Dedicated `+` |   `+` |   `+` | `+`      |        `+` | Keep plus literal before any closing delimiter.                                                        |

## Accepted tradeoffs

- `</` and `/=` use index-finger SFBs. Both are comfortable in practice, and `</` is easier than the
  former path involving the pinky.
- `\|` and `&` are adjacent left-home taps rather than a Shift-selected pair.
- `_` uses the inner-index `W` position instead of the outer-pinky `R` position.
- `-` and `+` are adjacent dedicated keys rather than a Shift-selected pair.
- Grave is separate from the quote key so direct Sym `"` can coexist with the delimiter stack.

The accepted grouping changes above bought direct Sym access, eliminated the known Shift/Sym
handoffs, and added the `./`, `/.`, and `~/.` family.
