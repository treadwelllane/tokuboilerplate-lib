local test = require("santoku.test")
local fs = require("santoku.fs")

test("tokuboilerplate", function()

  local db_file = os.tmpname()
  local db_mod = require("tokuboilerplate")
  local db = db_mod(db_file)

  test("add", function()
    local id = db.add()
    assert(id == 1)
    local row = db.get(id)
    assert(row.id == 1)
    assert(type(row.value) == "number")
  end)

  test("list", function()
    local numbers = db.list()
    assert(#numbers == 1)
  end)

  test("update", function()
    local val = db.update(1)
    assert(val)
    local new = db.get(1)
    assert(new.id == 1)
  end)

  test("delete", function()
    db.delete(1)
    assert(not db.delete(1))
    assert(#db.list() == 0)
  end)

  test("pass-through", function()
    local db2 = db_mod(db)
    assert(db2 == db)
  end)

  fs.rm(db_file)

end)
