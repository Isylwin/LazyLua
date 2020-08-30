local floor, infinite, random = math.floor, math.huge, math.random
local package = {}

--- Calculate the modular power for any exponent.
local function fmodpow(bse, exp, mod)
	bse = bse % mod
	local prod = 1
	while exp > 0 do
		if exp % 2 == 1 then
			prod = prod * bse % mod
		end
		exp = floor(exp / 2)
		bse = (bse ^ 2) % mod
	end
	return prod
end

local function witnesses(n)
	if n < 1373653 then
		return 2, 3
	elseif n < 4759123141 then
		return 2, 7, 61
	elseif n < 2152302898747 then
		return 2, 3, 5, 7, 11
	elseif n < 3474749660383 then
		return 2, 3, 5, 7, 11, 13
	else
		return 2, 325, 9375, 28178, 450775, 9780504, 1795265022
	end
end

--- Given a number n, returns numbers r and d such that 2^r*d+1 == n
--- Miller-Rabin primality test
local function miller_rabin(n, ...)
	local s, d = 0, n-1
	while d%2==0 do
		d, s = d/2, s+1
	end
	for i=1,select('#', ...) do
		local witness = select(i, ...)
		if witness >= n then break end
		local x = fmodpow(witness, d, n)
		if (x ~= 1) then
			local t = s
			while x ~= n - 1 do
				t = t - 1
				if t <= 0 then
					return false
				end
				x = (x * x) % n
				if x == 1 then
					return false
				end
			end
		end
	end
	return true
end


local function easyCheck(n)
	if n % 3 == 0 then
		return false
	end

	local i = 5

	while i*i <= n do
		if n % i == 0 or n % (i + 2) == 0 then
			return false
		end
		i = i + 6
	end

	return true
end

package.millerRabin = function(n) return miller_rabin(n, witnesses(n)) end
package.easyCheck = easyCheck

return package
