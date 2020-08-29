local function nats(k)
  local x = k or 1
  local co = coroutine.wrap(function ()
    while true do
      coroutine.yield(x)
      x = x + 1
    end
  end)

  return co
end


local function predicatedSequence(s, pred)
  local co = coroutine.wrap(function ()
    while true do
      local x = s()
      if pred(x) then coroutine.yield(x) end
    end
  end)
  return co
end


local function sieve(s)
  local seq = s

  local co = coroutine.wrap(function()
    while true do
      local x = seq()
      seq = predicatedSequence(seq, function(y)
        return y%x ~= 0 
      end)
      coroutine.yield(x)
    end
  end)
  return co
end


local function fetchNfromSequence(n, seq)
  local result = {}

  for i = 1,n do
    table.insert(result, seq())
  end

  return result
end


local N = 100
local result

local startTime = os.clock()

local seq = sieve(nats(2))
result = fetchNfromSequence(N, seq)

local endTime = os.clock()

print(string.format("Time: %.2f s", endTime - startTime))
print(table.concat(result, ','))

print("\nControl:")

-- sieve.lua
-- the sieve of Eratosthenes programmed with coroutines
-- typical usage: lua -e N=500 sieve.lua | column

-- generate all the numbers from 2 to n
function gen (n)
  return coroutine.wrap(function ()
    for i=2,n do coroutine.yield(i) end
  end)
end

-- filter the numbers generated by `g', removing multiples of `p'
function filter (p, g)
  return coroutine.wrap(function ()
    for n in g do
      if n%p ~= 0 then coroutine.yield(n) end
    end
  end)
end

local controlResult = {}

startTime = os.clock() 

x = gen(math.huge)		-- generate a seamingly infinite stream of numbers
while #controlResult < N do
  local n = x()		-- pick a number until done
  if n == nil then break end
  table.insert(controlResult, n)		-- must be a prime number
  x = filter(n, x)	-- now remove its multiples
end

endTime = os.clock()

print(string.format("ControlTime: %.2f s", endTime - startTime))
print(table.concat(controlResult, ','))
