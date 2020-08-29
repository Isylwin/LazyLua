logger = {}

local function writeLine(line)
  logger.write(line .. '\n')
end

local function writeTemp(line)
  logger.write(line, true)
  logger.write('\r', false)
end

local function stdoutWrite(line, forceFlush)
  io.write(line)
  if forceFlush == true then io.flush()
  elseif forceFlush == nil then logger.flush()
  end
end

local function enableFlush(value)
  if value then logger.flush = io.flush
  else logger.flush = function() end
  end
end

logger.writeLine = writeLine
logger.writeTemp = writeTemp
logger.write = stdoutWrite

logger.enableFlush = enableFlush

if logger.flush == nil then logger.enableFlush(false) end

return logger
