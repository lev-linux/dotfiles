-- Default configuration for Luasnip
require("plugins.configs.others").luasnip {
  history = false,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
}

-- Define Luasnip helpers
function LuasnipHelpers()
  local ls = require("luasnip")

  local extras = require "luasnip.extras"

  return {
    ls = ls,
    s = ls.snippet,
    sn = ls.snippet_node,
    isn = ls.indent_snippet_node,
    t = ls.text_node,
    i = ls.insert_node,
    f = ls.function_node,
    c = ls.choice_node,
    d = ls.dynamic_node,
    r = ls.restore_node,
    events = require "luasnip.util.events",
    ai = require "luasnip.nodes.absolute_indexer",
    l = extras.lambda,
    rep = extras.rep,
    p = extras.partial,
    m = extras.match,
    n = extras.nonempty,
    dl = extras.dynamic_lambda,
    fmt = require("luasnip.extras.fmt").fmt,
    fmta = require("luasnip.extras.fmt").fmta,
    conds = require "luasnip.extras.expand_conditions",
    postfix = require("luasnip.extras.postfix").postfix,
    types = require "luasnip.util.types",
    parse = require("luasnip.util.parser").parse_snippet,
    ms = ls.multi_snippet,
    k = require("luasnip.nodes.key_indexer").new_key,
  }
end

-- Define path
local path = vim.fn.stdpath "config" .. "/lua/custom/snippets"

-- Loop through all files in the path
for _, file in ipairs(vim.fn.readdir(path)) do
  -- Extract type and snippets
  local filetype = vim.fn.fnamemodify(file, ":t:r")
  local snippets = require("custom.snippets." .. filetype)

  -- Set priority
  require("luasnip").add_snippets(filetype, snippets, {
    default_priority = 1001
  })
end
