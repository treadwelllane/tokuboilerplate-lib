local env = {
  name = "tokuboilerplate-lib",
  version = "0.0.1-1",
  license = "MIT",
  dependencies = {
    "lua >= 5.1",
    "santoku >= 0.0.305-1",
  },
}

return {
  type = "lib",
  env = env,
}
