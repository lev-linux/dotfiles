local lh = LuasnipHelpers()
local c = require "custom.snippets.c"

return {
  unpack(c),

  -- using namespace std;
  lh.s("using", {
    lh.t "using namespace ",
    lh.i(1, "std"),
    lh.t ";",
    lh.i(0),
  }),

  -- file template
  lh.s("temp", {
    -- Includes
    lh.t "#include ",
    lh.i(1, "<iostream>"),
    lh.t { "", "" },
    lh.t "using namespace std;",
    lh.t { "", "", "" },

    -- Main function
    lh.t "int main(int argc, char *argv[]) {",
    lh.t { "", "  " },
    lh.i(0),
    lh.t { "", "", "  return 0;", "}" },
  }),
}
