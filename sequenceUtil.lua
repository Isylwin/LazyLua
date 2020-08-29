local sequenceUtil = {}

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


local function fetchNfromSequence(n, seq)
  local result = {}

  for i = 1,n do
    table.insert(result, seq())
  end

  return result
end

sequenceUtil.naturalNumbers = nats
sequenceUtil.predicatedSequence = predicatedSequence
sequenceUtil.fetchNfromSequence = fetchNfromSequence

return sequenceUtil
