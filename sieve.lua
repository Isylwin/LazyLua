local sequenceUtil = require 'sequenceUtil'

local package = {}

local function sieve(s)
  local seq = s

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

package.sieve = sieve
package.primeSequence = function() return sieve(sequenceUtil.naturalNumbers(2)) end

return package
