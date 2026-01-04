-- Arctic Abyssal: The Deep Sea Theme
-- Comprehensive support for Go, JS/TS, Python, C++, HTML, CSS
-- Optimized for Treesitter + LSP Semantic Tokens

local palette = {
  -- Base Layers (The Ocean Depths)
  base = "#0B0F18", -- Inky Midnight Blue (Main Background)
  mantle = "#080C14", -- Darker (Sidebars/Floating Windows)
  crust = "#05080E", -- Darkest (Statusline/Terminal)

  -- Surface Layers (UI Elements)
  surface0 = "#151B26", -- Lighter background (Line numbers)
  surface1 = "#1E2533", -- Selection background
  surface2 = "#283141", -- Borders and visible guides

  -- Text Levels
  text = "#F7F9FB", -- Arctic White (Main Text)
  subtext1 = "#D1D9E0", -- Slightly misted white (Parameters)
  subtext0 = "#AAB5BF", -- Muted gray-blue (Fields/Properties)
  overlay2 = "#7C8A9D", -- Inactive text
  overlay1 = "#5C6A82", -- Comments / Metadata

  -- Bioluminescent Accents
  teal = "#0FB5B3", -- Glacial Teal (Logic: Functions, Methods, Classes)
  ice = "#A8E6F1", -- Ice Blue (Data: Strings, Constants, Types, Values)
  cerulean = "#00869D", -- Deep Cerulean (Structure: Keywords, Preprocessors)
  cyan = "#12D6D3", -- Bright Cyan (Operators, Delimiters)

  -- Status
  error = "#E27878", -- Red
  warning = "#E2A478", -- Orange
  info = "#84A0C6", -- Blue
  hint = "#89B8C2", -- Cyan-Grey

  -- Diff/Git
  add = "#0FB5B3",
  change = "#A8E6F1",
  delete = "#E27878",
}

-- Setup
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.g.colors_name = "arctic-abyssal"

local hl = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- =============================================================================
--  1. EDITOR UI ELEMENTS
-- =============================================================================
hl("Normal", { fg = palette.text, bg = palette.base })
hl("NormalFloat", { fg = palette.text, bg = palette.mantle })
hl("FloatBorder", { fg = palette.cerulean, bg = palette.mantle })
hl("ColorColumn", { bg = palette.surface0 })
hl("Cursor", { fg = palette.base, bg = palette.teal })
hl("CursorLine", { bg = palette.surface0 })
hl("CursorColumn", { bg = palette.surface0 })
hl("LineNr", { fg = palette.overlay1 })
hl("CursorLineNr", { fg = palette.teal, bold = true })
hl("SignColumn", { bg = palette.base })

-- Window Dividers
hl("VertSplit", { fg = palette.surface1, bg = palette.base })
hl("WinSeparator", { fg = palette.surface1, bg = palette.base })

-- Tabs & Status
hl("TabLine", { bg = palette.mantle, fg = palette.overlay1 })
hl("TabLineFill", { bg = palette.crust })
hl("TabLineSel", { bg = palette.base, fg = palette.teal, bold = true })
hl("StatusLine", { bg = palette.crust, fg = palette.text })
hl("StatusLineNC", { bg = palette.crust, fg = palette.overlay1 })

-- Search & Selection
hl("Search", { bg = palette.cerulean, fg = palette.base })
hl("IncSearch", { bg = palette.teal, fg = palette.base })
hl("Visual", { bg = palette.surface1 }) -- Subtle selection
hl("MatchParen", { fg = palette.teal, bold = true, underline = true })

-- Popups (Pmenu)
hl("Pmenu", { bg = palette.mantle, fg = palette.subtext1 })
hl("PmenuSel", { bg = palette.teal, fg = palette.base, bold = true })
hl("PmenuSbar", { bg = palette.mantle })
hl("PmenuThumb", { bg = palette.overlay1 })

-- Diagnostics
hl("DiagnosticError", { fg = palette.error })
hl("DiagnosticWarn", { fg = palette.warning })
hl("DiagnosticInfo", { fg = palette.info })
hl("DiagnosticHint", { fg = palette.hint })
hl("DiagnosticUnderlineError", { undercurl = true, sp = palette.error })

-- =============================================================================
--  2. STANDARD SYNTAX (TREESITTER FALLBACKS)
-- =============================================================================
hl("Comment", { fg = palette.overlay1, italic = true })
hl("Constant", { fg = palette.ice })
hl("String", { fg = palette.ice })
hl("Character", { fg = palette.ice })
hl("Number", { fg = palette.ice })
hl("Boolean", { fg = palette.teal, bold = true })
hl("Float", { fg = palette.ice })

hl("Identifier", { fg = palette.text })
hl("Function", { fg = palette.teal, bold = true })
hl("Statement", { fg = palette.cerulean })
hl("Conditional", { fg = palette.cerulean, bold = true })
hl("Repeat", { fg = palette.cerulean, bold = true })
hl("Label", { fg = palette.cerulean })

hl("Operator", { fg = palette.cyan })
hl("Keyword", { fg = palette.cerulean, bold = true })
hl("Exception", { fg = palette.error })
hl("PreProc", { fg = palette.cerulean })
hl("Include", { fg = palette.cerulean })
hl("Define", { fg = palette.cerulean })
hl("Macro", { fg = palette.teal })

hl("Type", { fg = palette.ice })
hl("Structure", { fg = palette.ice })
hl("Typedef", { fg = palette.ice })
hl("Special", { fg = palette.teal })
hl("SpecialChar", { fg = palette.teal })
hl("Delimiter", { fg = palette.overlay2 })

-- =============================================================================
--  3. TREESITTER & LANGUAGE SPECIFICS
-- =============================================================================

-- --- GENERIC TREESITTER ---
hl("@variable", { fg = palette.text })
hl("@variable.builtin", { fg = palette.ice, italic = true }) -- self, this
hl("@parameter", { fg = palette.subtext1, italic = true })
hl("@property", { fg = palette.subtext0 })
hl("@field", { fg = palette.subtext0 })
hl("@constructor", { fg = palette.teal })
hl("@function.builtin", { fg = palette.teal, italic = true })
hl("@keyword.function", { fg = palette.cerulean, bold = true })
hl("@keyword.operator", { fg = palette.cerulean })
hl("@punctuation.bracket", { fg = palette.subtext0 })
hl("@punctuation.delimiter", { fg = palette.cyan })

-- --- GO LANG SUPPORT ---
hl("@type.go", { fg = palette.ice, bold = true }) -- Structs/Interfaces
hl("@type.builtin.go", { fg = palette.ice, italic = true }) -- int, string, error
-- The Receiver: "func (r *Receiver) Method()"
hl("@variable.receiver.go", { fg = palette.subtext1, italic = true })
hl("@type.receiver.go", { fg = palette.ice, bold = true })
-- Methods vs Functions
hl("@method.go", { fg = palette.teal }) -- Struct methods
hl("@function.go", { fg = palette.teal, bold = true }) -- Standalone functions
-- Specifics
hl("@keyword.function.go", { fg = palette.cerulean })
hl("@keyword.return.go", { fg = palette.cerulean, bold = true })
hl("@operator.go", { fg = palette.cyan }) -- :=, &
hl("@comment.note.go", { fg = palette.cerulean, italic = true }) -- //go:build

-- --- JAVASCRIPT / TYPESCRIPT ---
hl("@variable.builtin.javascript", { fg = palette.ice, italic = true }) -- this
hl("@variable.builtin.typescript", { fg = palette.ice, italic = true }) -- this
hl("@tag.javascript", { fg = palette.teal }) -- JSX Component <Comp />
hl("@tag.builtin.javascript", { fg = palette.cerulean }) -- JSX HTML <div />
hl("@tag.attribute.javascript", { fg = palette.subtext1, italic = true }) -- props
hl("@constructor.typescript", { fg = palette.teal })
hl("@type.typescript", { fg = palette.ice, bold = true })

-- --- PYTHON ---
hl("@function.builtin.python", { fg = palette.teal, italic = true }) -- len(), print()
hl("@variable.builtin.python", { fg = palette.ice, italic = true }) -- self, cls
hl("@attribute.python", { fg = palette.ice, italic = true }) -- @decorators
hl("@string.documentation.python", { fg = palette.overlay1, italic = true }) -- docstrings

-- --- C++ / C ---
hl("@keyword.directive.cpp", { fg = palette.cerulean }) -- #include
hl("@type.cpp", { fg = palette.ice, bold = true })
hl("@namespace.cpp", { fg = palette.subtext0 })
hl("@constant.macro.cpp", { fg = palette.teal })

-- --- HTML ---
hl("@tag.html", { fg = palette.teal, bold = true })
hl("@tag.attribute.html", { fg = palette.ice, italic = true })
hl("@tag.delimiter.html", { fg = palette.subtext0 })
hl("@string.html", { fg = palette.subtext1 }) -- content inside string quotes

-- --- CSS / SCSS ---
hl("@property.css", { fg = palette.subtext1 }) -- color, margin
hl("@keyword.css", { fg = palette.teal, italic = true }) -- @media, @keyframes
hl("@type.css", { fg = palette.teal }) -- html tags in css
hl("@string.css", { fg = palette.ice })
hl("@number.css", { fg = palette.ice })
hl("@function.css", { fg = palette.teal }) -- url(), rgb()
hl("cssClassName", { fg = palette.teal })
hl("cssIdentifier", { fg = palette.cerulean, bold = true }) -- #id

-- =============================================================================
--  4. LSP SEMANTIC TOKENS (The "Smart" Layer)
-- =============================================================================
-- These override Treesitter when the LSP is active and knows better
hl("@lsp.type.namespace", { fg = palette.subtext0 })
hl("@lsp.type.type", { fg = palette.ice })
hl("@lsp.type.class", { fg = palette.ice, bold = true })
hl("@lsp.type.enum", { fg = palette.ice })
hl("@lsp.type.interface", { fg = palette.teal, italic = true })
hl("@lsp.type.struct", { fg = palette.ice, bold = true })
hl("@lsp.type.parameter", { fg = palette.subtext1, italic = true })
hl("@lsp.type.variable", { fg = palette.text })
hl("@lsp.type.property", { fg = palette.subtext0 })
hl("@lsp.type.enumMember", { fg = palette.ice, italic = true })
hl("@lsp.type.function", { fg = palette.teal, bold = true })
hl("@lsp.type.method", { fg = palette.teal })
hl("@lsp.type.macro", { fg = palette.cerulean })
hl("@lsp.type.decorator", { fg = palette.ice, italic = true })
hl("@lsp.mod.readonly", { fg = palette.ice }) -- Constants usually

-- =============================================================================
--  5. COMMON PLUGINS
-- =============================================================================

-- Telescope
hl("TelescopeBorder", { fg = palette.surface2, bg = palette.mantle })
hl("TelescopePromptBorder", { fg = palette.teal, bg = palette.mantle })
hl("TelescopePromptTitle", { fg = palette.base, bg = palette.teal, bold = true })
hl("TelescopePreviewTitle", { fg = palette.base, bg = palette.ice, bold = true })
hl("TelescopeSelection", { bg = palette.surface1, bold = true })

-- GitSigns
hl("GitSignsAdd", { fg = palette.add, bg = palette.base })
hl("GitSignsChange", { fg = palette.change, bg = palette.base })
hl("GitSignsDelete", { fg = palette.delete, bg = palette.base })

-- NvimTree
hl("NvimTreeRootFolder", { fg = palette.teal, bold = true })
hl("NvimTreeFolderIcon", { fg = palette.ice })
hl("NvimTreeFolderName", { fg = palette.text })
hl("NvimTreeGitDirty", { fg = palette.warning })
hl("NvimTreeGitNew", { fg = palette.add })
