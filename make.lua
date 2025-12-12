local env = {
  name = "tokuboilerplate",
  version = "0.0.1-1",
  license = "MIT",
  cflags = {
    "-Wall", "-Wextra",
    "-I$(shell luarocks show santoku --rock-dir)/include/",
  },
  dependencies = {
    "lua >= 5.1",
    "santoku >= 0.0.314-1",
    "santoku-sqlite >= 0.0.29-1",
    "santoku-sqlite-migrate >= 0.0.19-1",
    "lsqlite3 >= 0.9.6-1",
    "argparse >= 0.7.1-1",
  },
  test = {
    dependencies = {
      "santoku-fs >= 0.0.41-1",
    },
  },
}

return {
  type = "lib",
  env = env,
}
