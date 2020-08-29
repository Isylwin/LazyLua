local package = {}

local function gen (n)
  return coroutine.wrap(function ()
    for i=2,n do coroutine.yield(i) end
  end)
end


local function genInf()
  return coroutine.wrap(function ()
    local i = 2
    while true do coroutine.yield(i); i = i + 1 end
  end)
end


local function filter (p, seq)
  return coroutine.wrap(function ()
    for n in seq do
      if n%p ~= 0 then coroutine.yield(n) end
    end
  end)
end

local function enemySieve(n_primes)
  local result = {}

  local seq = genInf(math.huge)
  while #result < n_primes do
    local n = seq()
    if n == nil then break end
    table.insert(result, n)
    seq = filter(n, seq)
  end

  return result
end

package.enemySieve = enemySieve

return package
