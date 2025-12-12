<%
  local fs = require("santoku.fs")
  local serialize = require("santoku.serialize")
  local migrations = {}
  for fp in fs.files("res/migrations") do
    migrations[fs.basename(fp)] = readfile(fp)
  end
  t_migrations = serialize(migrations, true)
%>

local lsqlite3 = require("lsqlite3")
local sqlite = require("santoku.sqlite")
local sqlite_migrate = require("santoku.sqlite.migrate")
local capi = require("tokuboilerplate.capi")

return function (db_file)
  if type(db_file) == "table" then
    return db_file
  end

  local M = {}
  local db = sqlite(lsqlite3.open(db_file))

  db.exec("pragma journal_mode = WAL")
  db.exec("pragma synchronous = NORMAL")
  db.exec("pragma busy_timeout = 5000")

  sqlite_migrate(db, <% return t_migrations %>)

  M.db = db

  local insert_number = db.inserter([[
    insert into numbers (value) values (?1)
  ]])

  local delete_number = db.runner([[
    delete from numbers where id = ?1
  ]])

  local update_number = db.runner([[
    update numbers set value = ?1 where id = ?2
  ]])

  local get_all_numbers = db.all([[
    select id, value from numbers order by id
  ]], true)

  local get_number = db.getter([[
    select id, value from numbers where id = ?1
  ]], true)

  function M.add()
    local value = capi.random()
    return insert_number(value)
  end

  function M.delete(id)
    delete_number(id)
  end

  function M.update(id)
    local value = capi.random()
    update_number(value, id)
    return value
  end

  function M.list()
    return get_all_numbers()
  end

  function M.get(id)
    return get_number(id)
  end

  return M
end
