local lh = LuasnipHelpers()

return {
  -- cond ? then : else
  lh.s("ter", {
    lh.i(1, "cond"),
    lh.t " ? ",
    lh.i(2, "then"),
    lh.t " : ",
    lh.i(3, "else"),
    lh.t ";",
    lh.i(0),
  }),
}


