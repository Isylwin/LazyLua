local logger = require 'logger'

local package = {}

local function report_ms(time)
  return string.format("%.2f ms", time * 1000)
end


local function report_us(time)
  return string.format("%.2f us", time * 1000000)
end


local function benchHelper(func, subIterations)
  return coroutine.wrap(function()
    while true do
      local x

      local startTime = os.clock()

      for i = 1,subIterations do
        x = func()
      end

      local endTime = os.clock()

      coroutine.yield( endTime - startTime, x)
    end
  end)

end


local function bench(func, iterations, benchName) -- Note: only works with functions that return a single result.
  if iterations > 10 and iterations % 10 ~= 0 then
    error("Please provide a multiple of 10 or a number below 10 for iterations!")
  end

  local subIterations = math.max(iterations / 10, 1)
  local metaIterations = math.min(iterations/subIterations, 10)

  logger.writeLine(string.format("Starting benchmark for '%s' with %d iterations", benchName, iterations))
  logger.writeLine(string.format("Divided iterations into %d meta-iterations and %d sub-iterations", metaIterations, subIterations))

  local progressReporter = function(i) return string.format("Iteration: %d/%d", i, metaIterations) end
  local helper = benchHelper(func, subIterations)

  local timeCounter = 0
  local x

  for i = 1,metaIterations do
    logger.writeTemp(progressReporter(i))
    local resultTime, result = helper() -- Haha compiler optimization goes brrrrrrr

    timeCounter = timeCounter + resultTime
    x = result
  end

  local time = (timeCounter) / iterations
  local logString = string.format("Time for '%s': %s", benchName, package.timeString(time))

  logger.writeLine(logString)

  return x
end

package.bench = bench
package.timeString = report_ms

package.report_ms = report_ms
package.report_us = report_us

return package
