local sequenceUtil = require 'sequenceUtil'
local enemySieve = require 'enemySieve'
local mySieve = require 'sieve'

local benchUtil = require 'benchUtil'
local logger = require 'logger'
logger.enableFlush(true)

n = tonumber(arg[1]) or 100
iterations = tonumber(arg[2]) or 100

local myCode = function()
  local seq = mySieve.primeSequence()
  return sequenceUtil.fetchNfromSequence(n, seq)
end

local theirCode = function()
  return enemySieve.enemySieve(n)
end

logger.writeLine(string.format("Fetching %d primes!", n))
logger.writeLine(string.format("Running benchmark for %d iterations!", iterations))

logger.writeLine('')

logger.writeLine("My code:")
local result = benchUtil.bench(myCode, iterations, "My code")
--print(table.concat(result, ','))

logger.writeLine('')

logger.writeLine("Control:")
local controlResult = benchUtil.bench(theirCode, iterations, "Enemy code")
--print(table.concat(controlResult, ','))
