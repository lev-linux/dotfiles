# dwmblocks Configuration

This is a custom configuration for `dwmblocks`, a modular status bar for `dwm`. The configuration defines the behavior of status blocks, their update intervals, and the appearance of delimiters.

## Features
- **Minimalist design**: No leading or trailing delimiters for a clean look.
- **Unicode-friendly**: Supports Unicode characters in block outputs.
- **Efficient updates**: Blocks update at different intervals for optimized performance.
- **Non-clickable blocks**: Ensures a purely informational status bar.

## Configuration Details

### General Settings
- **Delimiter:** `""` (empty, meaning no explicit separator between blocks)
- **Max Block Output Length:** `45` characters per block
- **Clickable Blocks:** Disabled (`0`)
- **Leading Delimiter:** Disabled (`0`)
- **Trailing Delimiter:** Disabled (`0`)

### Block Definitions
Blocks are defined using the `X(icon, cmd, interval, signal)` macro.

| Icon  | Script | Update Interval | Signal |
|-------|--------|----------------|--------|
| `|\x01` | `sb-date` | `1s` | `0` |
| `|\x01` | `sb-netbars` | `2s` | `0` |
| `;|\x02` | `sb-battery` | `1s` | `0` |
| `>\x01` | `sb-brightness` | On Signal `6` | `6` |
| `>\x02` | `sb-volume` | On Signal `1` | `1` |
| `>\x01` | `sb-xkeyboard` | On Signal `7` | `7` |
| `;|\x01` | `sb-disk` | On Demand | `0` |
| `<\x02` | `sb-cpubars` | `2s` | `0` |
| `<\x01` | `sb-cputemp` | `2s` | `0` |
| `<\x02` | `sb-ram` | `4s` | `0` |

### Powerline Icons Explanation
This configuration makes use of **DWM Powerline Arrows patch** and **DWM Multiple Status Bar patch** to create a visually appealing status bar with seamless arrow-like separators. These Unicode characters help merge blocks smoothly.

| Symbol  | Unicode  | Description |
|---------|---------|-------------|
| `|`     | `U+007C` | Vertical bar separator |
| `>`     | `U+E0B0` | Right-facing arrow (Powerline separator) |
| `<`     | `U+E0B2` | Left-facing arrow (Powerline separator) |
| `;`     | `U+E0B1` | Status bar separator |

- **`|` (`U+007C`)**: Simple vertical bar used as a separator between blocks.
- **`>` (`U+E0B0`)**: Right-facing Powerline separator, often used to merge a block with the next one seamlessly.
- **`<` (`U+E0B2`)**: Left-facing Powerline separator, generally used to indicate a transition from one block to another.

To properly display these symbols, you need a **patched font** (e.g., Nerd Fonts or Powerline Fonts), such as:
- **JetBrains Mono Nerd Font**
- **Hack Nerd Font**
- **Iosevka Nerd Font**

If you see unknown characters or squares instead, install a patched font.

## Installation
1. Clone `dwmblocks` if you haven't already:
   ```sh
   git clone https://github.com/torrinfail/dwmblocks.git
   ```
2. Copy the `config.h` file into the `dwmblocks` directory.
3. Compile and install:
   ```sh
   make clean install
   ```
4. Add `dwmblocks` to your `.xinitrc` or autostart script:
   ```sh
   dwmblocks &
   ```

## Customization
Modify `config.h` to change scripts, update intervals, icons, or enable clickability. Recompile `dwmblocks` after changes:
```sh
make clean install
```
