local sequenceUtil = require 'sequenceUtil'

local package = {}

local function sieve()
  local seq = sequenceUtil.nats(2)

  local co = coroutine.wrap(function()
    while true do
      local x = seq()
      seq = sequenceUtil.predicatedSequence(seq, function(y)
        return y%x ~= 0
      end)
      coroutine.yield(x)
    end
  end)
  return co
end


local function fastSieve(check, startN)
  if type(check) ~= 'function' then error("Must provide prime checking function!", 2) end

  startN = startN or 2
  local precomputed = { 2, 3 }

  if startN < 2 then error("n must be larger than one!", 2)
  elseif startN == 3 then precomputed = { 3 }
  elseif startN > 3 then precomputed = {}
  end

  if startN % 2 == 0 then startN = startN + 1 end

  local co = coroutine.wrap(function()
    for _, v in ipairs(precomputed) do
      coroutine.yield(v)
    end

    local n = #precomputed > 0 and 5 or startN

    while true do
      if check(n) then
        coroutine.yield(n)
      end
      n = n + 2
    end

  end)

  return co
end

package.sieve = sieve
package.fastSieve = fastSieve

return package
