local sequenceUtil = require 'sequenceUtil'
local primeSequence = require 'primeSequence'
local primeChecker = require 'primeChecker'

local benchUtil = require 'benchUtil'
local logger = require 'logger'
logger.enableFlush(true)

n = tonumber(arg[1]) or 100
start = tonumber(arg[2] or 2)
iterations = tonumber(arg[3]) or 100

local myCode = function()
  local seq = primeSequence.sieve()
  return sequenceUtil.fetchNfromSequence(n, seq)
end

local fastSieve = function()
  local seq = primeSequence.fastSieve(primeChecker.easyCheck, start)
  return sequenceUtil.fetchNfromSequence(n, seq)
end

local benchTable = {}

--table.insert(benchTable, {Name = "Sieve", Func = myCode})
table.insert(benchTable, {Name = "FastSieve", Func = fastSieve})

logger.writeLine(string.format("Fetching %d primes!", n))
logger.writeLine(string.format("Running benchmark for %d iterations!", iterations))

logger.writeLine('')

for _, value in ipairs(benchTable) do
  logger.writeLine(value.Name .. ":")
  local result = benchUtil.bench(value.Func, iterations, value.Name)
  if arg[4] then logger.writeLine(table.concat(result, ',')) end

  logger.writeLine('')
end
