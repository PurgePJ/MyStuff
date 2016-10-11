function WriteFile(text, path, mode)
	assert(type(text) == "string" and type(path) == "string" and (not mode or type(mode) == "string"), "WriteFile: wrong argument types (<string> expected for text, path and mode)")
	local file = io.open(path, mode or "w+")
	file:write(text)
	file:close()
	return true
end

function GetFileSize(path)
	assert(type(path) == "string", "GetFileSize: wrong argument types (<string> expected for path)")
	local file = io.open(path, "r")
	local size = file:seek("end")
	file:close()
	return size
end

function ReadFile(path)
	assert(type(path) == "string", "ReadFile: wrong argument types (<string> expected for path)")
	local file = io.open(path, "r")
	local text = file:read("*all")
	file:close()
	return text
end

function FileExist(path)
	assert(type(path) == "string", "FileExist: wrong argument types (<string> expected for path)")
	local file = io.open(path, "r")
	if file then file:close() return true else return false end
end

-- end of File functions

-- op is just a table with simple mathematical operations
op = {
    add = function(a, b) return a + b end,
    sub = function(a, b) return a - b end,
    mul = function(a, b) return a * b end,
    div = function(a, b) return a / b end,
    gt  = function(a, b) return a > b end,
    lt  = function(a, b) return a < b end,
    eq  = function(a, b) return a == b end,
    le  = function(a, b) return a <= b end,
    ge  = function(a, b) return a >= b end,
    ne  = function(a, b) return a ~= b end,
}

-- Applies a given function on every element in a given table and returns a new table
-- EXAMPLE: map(function(x) return x*x end, {1, 2, 3, 4}) => 1, 4, 9, 16
function map(func, tbl)
    local newtbl = {}
    for v in pairs(tbl) do
        newtbl[#newtbl+1] = func(v)
    end
    return newtbl
end


-- Applies a given function on every element in a given table and returns a new table with all elements where the function returned true
-- EXAMPLE: filter(function(x) return x > 2 end, {1, 2, 3, 4}) => 3, 4
function filter(func, tbl)
    local newtbl= {}
    for v in pairs(tbl) do
        if func(v) then
            newtbl[#newtbl+1]=v
        end
    end
    return newtbl
end

function foldr(func, val, tbl)
    for v in pairs(tbl) do
        val = func(val, v)
    end
    return val
end


--[[
Very hard to explain, it takes a given function and uses the first 2 elements of a given table as parameters, then it uses the function again with the result of the first function and the next element in the table as parameters and so on.
SOME EXAMPLES:
reduce(function(a,c) return a + c end, {1, 2, 3, 4}) => 10
reduce(function(a,c) return a * c end, {1, 2, 3, 4}) => 24
reduce(function(a,c) return a - c end, {1, 2, 3, 4}) => -8
]]
function reduce(func, tbl)
    return foldr(func, tbl[1], tail(tbl))
end


--[[
Binds a given parameter to the first or second parameter of a given function
local mul5 = bind1st(op.mul, 5) => mul5(10) => 50
local sub2 = bind2nd(op.sub, 2) => sub2(5) => 3
]]
function bind1st(func, val1)
    return function (val2)
        return func(val1, val2)
    end
end

-- Almost the same as bind1st
function bind2nd(func, val2)
    return function (val1)
        return func(val1, val2)
    end
end


-- Returns all elements except the first of a given table
-- EXAMPLE: tail({1, 2, 3, 4}) => 2, 3, 4
function tail(tbl)
    if #tbl < 1 then
        return nil
    else
        local newtbl = {}
        for i, v in pairs(tbl) do
            if i > 1 then
                newtbl[#newtbl+1] = v
            end
        end
        return newtbl
    end
end