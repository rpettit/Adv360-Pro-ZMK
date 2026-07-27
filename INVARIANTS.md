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
| The right bottom keywell row is easy to reach and sits inline with the upper thumb-cluster keys.          | It carries `% : ^ $`.                                                                                                 |
| The inner edge of either keywell is a rough reach.                                                        | Avoid using the extra inner keys unless a binding is particularly infrequent.                                         |
| The first key immediately beyond the right and left pinkies are usable; the farther outer keys are rough. | Do not move frequent symbols outward merely to improve an abstract grid.                                              |
| Index-finger same-finger sequences are acceptable when they don't scissor.                                | The current `</` and `/=` paths are acceptable; `</` is preferable to its former pinky-involving path.                |

## Delimiter selection invariants

| Pair | Preferred selector | Compatibility selector |
| ---- | ------------------ | ---------------------- |
| `()` | None               | —                      |
| `{}` | Shift              | —                      |
| `[]` | Ctrl               | —                      |
| `<>` | Left Alt           | Shift+Ctrl             |

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

| Key           | Plain   | Shift         | Ctrl         | Shift+Ctrl | Left Alt on Sym | Purpose                                                                                                |
| ------------- | ------: | ------------: | ------------ | ---------: | --------------: | ------------------------------------------------------------------------------------------------------ |
| `=`           |     `=` |           `=` | `Ctrl+=`     |        `=` |             `=` | Protect `:=`, `!=`, `?=`, `<=`, `>=`, and other equality endings from becoming `+`.                    |
| `/`           |     `/` |           `\` | `Ctrl+/`     |        `/` |             `/` | Retain the normal `/\` pair while keeping angle/slash sequences literal under a delimiter hold.        |
| Dedicated `-` |     `-` |           `-` | `-`          |        `-` |             `-` | Keep minus literal when delimiter modifiers are retained.                                              |
| Dedicated `+` |     `+` |           `+` | `+`          |        `+` |             `+` | Keep plus literal before any closing delimiter.                                                        |
| Space tap     | `Space` | `Shift+Space` | `Ctrl+Space` |    `Space` |         `Space` | Keep trailing space literal; Right Alt remains available for ordinary `Alt+Space`.                     |

## Accepted tradeoffs

- `</` and `/=` use index-finger SFBs. Both are comfortable in practice, and `</` is easier than the
  former path involving the pinky.
- `\|` and `&` are adjacent left-home taps rather than a Shift-selected pair.
- `_` uses the home-index `D` position; the inner-index `W` position remains transparent.
- `-` and `+` are adjacent dedicated keys rather than a Shift-selected pair.
- Grave is separate from the quote key so direct Sym `"` can coexist with the delimiter stack.
- Left `Alt+Space` is reserved for a literal trailing Space after an angle; use Right Alt for an
  ordinary `Alt+Space` shortcut.

The accepted grouping changes above bought direct Sym access, eliminated the known Shift/Sym
handoffs, and added the `./`, `/.`, and `~/.` family.
