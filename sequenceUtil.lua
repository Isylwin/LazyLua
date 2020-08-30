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


local function odds(k)
  local x = k or 1
  if x%2 == 0 then error("Cannot start odd sequence with even number!") end

  local co = coroutine.wrap(function ()
    while true do
      coroutine.yield(x)
      x = x + 2
    end
  end)

  return co
end


local function predicatedSequence(s, pred)
  local co = coroutine.wrap(function ()
    for x in s do
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

sequenceUtil.nats = nats
sequenceUtil.odds = odds
sequenceUtil.predicatedSequence = predicatedSequence
sequenceUtil.fetchNfromSequence = fetchNfromSequence

return sequenceUtil
