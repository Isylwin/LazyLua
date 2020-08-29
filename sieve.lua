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

local function bench(func, iterations)
  local startTime = os.clock()
  
  local x
  
  for i = 1,iterations do
    x = func() -- Haha compiler optimization goes brrrrrrr
  end

  local endTime = os.clock()

  print(string.format("Time: %.2f ms", ((endTime - startTime)/iterations)*1000))
  return func()
end

N = tonumber(arg[1]) or 500
iterations = tonumber(arg[2]) or 100

print(string.format("Fetching %d primes!", N))
print(string.format("Running benchmark for %d iterations!\n", iterations))

local myCode = function()
  local seq = sieve(nats(2))
  return fetchNfromSequence(N, seq)
end

local result = bench(myCode, iterations)

print(table.concat(result, ','))

print("\nControl:")

function gen (n)
  return coroutine.wrap(function ()
    for i=2,n do coroutine.yield(i) end
  end)
end

function filter (p, g)
  return coroutine.wrap(function ()
    for n in g do
      if n%p ~= 0 then coroutine.yield(n) end
    end
  end)
end

local theirCode = function()
  local result = {}

  x = gen(math.huge)
  while #result < N do
    local n = x()
    if n == nil then break end
    table.insert(result, n)
    x = filter(n, x)
  end

  return result
end

local controlResult = bench(theirCode, iterations)

print(table.concat(controlResult, ','))
