#include <santoku/lua/utils.h>

static inline int get_random (lua_State *L)
{
  lua_pushinteger(L, (lua_Integer)tk_fast_random());
  return 1;
}

static luaL_Reg fns[] = {
  { "random", get_random },
  { NULL, NULL }
};

int luaopen_tokuboilerplate_capi (lua_State *L)
{
  lua_newtable(L);
  luaL_register(L, NULL, fns);
  return 1;
}
