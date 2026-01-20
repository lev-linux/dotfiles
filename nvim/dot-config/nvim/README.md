# Neovim Configuration

A single-file Neovim configuration focused on productivity with LSP, completion, Git integration, and AI assistance.

## Features

- **Plugin Management**: [lazy.nvim](https://github.com/folke/lazy.nvim) with lazy loading
- **LSP**: Mason for automatic server installation, configured for Lua, Python, C/C++, Bash, HTML/CSS, and LaTeX
- **Completion**: nvim-cmp with LSP, snippets (UltiSnips), buffer, and path sources
- **AI**: GitHub Copilot integration with CopilotChat
- **Git**: Fugitive, Gitsigns for inline blame and hunk navigation
- **Navigation**: Telescope fuzzy finder, nvim-tree file explorer, Hop for quick jumps
- **Editing**: Treesitter syntax highlighting, nvim-surround, autopairs, vim-sleuth for auto-indentation
- **UI**: Gruvbox theme (auto light/dark via darkman), lualine statusline, bufferline

## Key Mappings

| Key | Mode | Action |
|-----|------|--------|
| `<Space>` | n | Leader key |
| `;` / `:` | n,v | Swapped |
| `gl` / `gh` | n,v | End/start of line |
| `jk` | i | Exit insert mode |

### Navigation
| Key | Mode | Action |
|-----|------|--------|
| `<C-h/j/k/l>` | n | Window navigation |
| `<Tab>` / `<S-Tab>` | n | Next/prev buffer |
| `<leader>h` | n,v | Hop to char |
| `<leader>ww` | n,v | Hop to word |

### Files & Search
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Find buffers |
| `<leader>fh` | Help tags |
| `<leader>fw` | Fuzzy find in buffer |
| `<C-n>` | Toggle file tree |
| `<leader>o` | Focus file tree |

### LSP
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gi` | Implementation |
| `K` | Hover docs |
| `<leader>ra` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>fm` | Format buffer |
| `<leader>lf` | Line diagnostics |
| `[d` / `]d` | Prev/next diagnostic |

### Git
| Key | Action |
|-----|--------|
| `<leader>gs` | Git status |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gl` | Git log |
| `<leader>gb` | Blame line |
| `<leader>st` | Stage hunk |
| `<leader>ph` | Preview hunk |
| `[c` / `]c` | Prev/next hunk |

### Copilot
| Key | Action |
|-----|--------|
| `<leader>cc` | Open Copilot Chat |
| `<leader>ct` | Toggle Copilot Chat |

### Terminal
| Key | Action |
|-----|--------|
| `<A-h>` | Toggle horizontal terminal |
| `<A-v>` | Toggle vertical terminal |

## Requirements

- Neovim ≥ 0.9
- Git
- [darkman](https://gitlab.com/WhyNotHugo/darkman) (optional, for auto light/dark theme)
- A [Nerd Font](https://www.nerdfonts.com/) for icons
- `xclip` or `wl-copy` for clipboard support

## Installation

```bash
git clone https://github.com/<user>/nvim-config ~/.config/nvim
nvim
