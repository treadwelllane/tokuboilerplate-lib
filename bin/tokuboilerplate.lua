#!/usr/bin/env lua

local argparse = require("argparse")
local db_mod = require("tokuboilerplate")

local parser = argparse()
  :name("tokuboilerplate")
  :description("CLI for managing random numbers in a SQLite database")

parser
  :option("--sqlite", "SQLite database file")
  :args("1")
  :count("1")

parser:command("add", "Add a new random number")

local delete_cmd = parser:command("delete", "Delete a number by ID")
delete_cmd:argument("id", "ID of the number to delete"):convert(tonumber)

local update_cmd = parser:command("update", "Regenerate a random number by ID")
update_cmd:argument("id", "ID of the number to update"):convert(tonumber)

parser:command("list", "List all numbers (id, value)")

local args = parser:parse()
local db = db_mod(args.sqlite)

if args["add"] then
  local id = db.add()
  local row = db.get(id)
  print(string.format("Added: id=%d value=%d", row.id, row.value))

elseif args["delete"] then
  if db.delete(args.id) then
    print(string.format("Deleted: id=%d", args.id))
  else
    print(string.format("Not found: id=%d", args.id))
  end

elseif args["update"] then
  local ok, value = db.update(args.id)
  if ok then
    print(string.format("Updated: id=%d value=%d", args.id, value))
  else
    print(string.format("Not found: id=%d", args.id))
  end

elseif args["list"] then
  local numbers = db.list()
  if #numbers == 0 then
    print("No numbers in database")
  else
    for _, row in ipairs(numbers) do
      print(string.format("id=%d value=%d", row.id, row.value))
    end
  end
end
