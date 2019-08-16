local MAXLEN = 64

local graphs = {}
local trgrs = {}
local paused = false

function createGraph(id, opts)
	local g = graphs[id]
	if g == nil or not g.x then
		while id > 1 and id > #graphs do
			graphs[#graphs+1] = {}
		end
		g = opts
		g.id = id
		g.values = {}
		g.lastRun = 0
		g.sum = 0
		g.dp = math.ceil(g.w / MAXLEN)
		g.h = g.h - 2 -- bottom offset
		g.w = g.w - 1 -- right offset
		graphs[id] = g
		return
	end

	-- Y-line
	lcd.drawLine(g.x + 1, g.y, g.x + 1, g.y + g.h + 1, SOLID, FORCE)
	lcd.drawPoint(g.x, g.y)
	if g.crit ~= nil then
		lcd.drawPoint(g.x, math.floor(g.y + (g.max - g.crit) * ((g.h-1) / (g.max - g.min))))
	end

	-- X-line
	lcd.drawLine(g.x, g.y + g.h, g.x + g.w, g.y + g.h, SOLID, FORCE)

	if paused then
		lcd.drawText(g.x + (g.w / 2) - 20, g.y + (g.h / 2) - 4, "paused", SMLSIZE+BLINK+INVERS)
	end

	if not g.values or #(g.values) < 2 then
		return
	end

	for j, value in pairs(g.values) do
		if not g.values[j+1] then break end
		local nxtVal = g.values[j+1]

		if value < g.min then value = g.min end
		if value > g.max then value = g.max end
		if nxtVal < g.min then nxtVal = g.min end
		if nxtVal > g.max then nxtVal = g.max end

		local range = g.max - g.min
		local maxY = g.y
		local minY = g.h + g.y - 1
		local curY = math.floor(maxY + (g.max - value) * ((g.h-1) / range))
		local nxtY = math.floor(maxY + (g.max - nxtVal) * ((g.h-1) / range))
		local lineForm = g.style or (((nxtY >= minY and curY >= minY) or (nxtY <= maxY and curY <= maxY)) and DOTTED or SOLID)


		if g.crit ~= nil then
			lineForm = (value <= g.crit and nxtVal <= g.crit) and DOTTED or SOLID
		end

		lcd.drawLine(g.x + (j*g.dp) - g.dp + 2, curY, g.x + ((j+1)*g.dp) - g.dp + 2, nxtY, lineForm, FORCE)
	end
end

function getGraphAverage(id)
	if graphs[id] == nil or not graphs[id].values then
		return 0
	end
	local g = graphs[id]
	return g.sum ~= 0 and g.sum / #(g.values) or 0
end

local function init()
	trgrs = assert(loadScript("/SCRIPTS/GRAPHS/trigger.lua"))()
	for j, t in pairs(trgrs) do
		trgrs[j].state = t.func()
	end
end

local function update()
	-- triggers
	for j, t in pairs(trgrs) do
		local trg = t.func()
		if trg ~= t.state then
			trgrs[j].state = trg
		end
	end
	paused = trgrs.pause.state

	if paused then return end

	for i=1,#(graphs) do
		local g = graphs[i]
		if g.values then
			if g.lastRun == 0 or g.lastRun + g.speed < getTime() then
				local maxValues = math.ceil(g.w / g.dp)
				local vals = g.values

				if #vals >= maxValues then
					local tmp = {}
					for j=1,#(vals) do
						if j > 1 then
							tmp[j-1] = vals[j]
						end
					end
					g.sum = g.sum - vals[1]
					vals = tmp
				end

				local v
				if type(g.src) == "function" then
					v = assert(g.src)()
				else
					v = getValue(g.src)
				end

				g.sum = g.sum + v
				vals[#vals+1] = v
				g.values = vals
				g.lastRun = getTime()
				graphs[i] = g
			end
		end
	end
end

return { run=update, init=init }
