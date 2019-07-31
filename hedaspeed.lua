-- Headspead calculator widget by Bjorn Pasteuning, 2018
-- Based on Tadango's scripting.

local options = {
	{ "RPM", SOURCE, 1 }, -- Defines source for the RPM Sensor
	{ "Throttle", SOURCE, 1}, -- Defines source for internal Throttle output Normaly (Futaba CH3)
	{ "Pinion", VALUE, 13, 1, 50 }, -- Motor Pinion Teeth
	{ "Maingear", VALUE, 110, 10, 200 }, -- Maingear Teeth
	{ "Color", COLOR, WHITE }, -- Color of the RPM readout
	{ "Shadow", BOOL, 0}, -- Currently not visible in the Widget settings menu
}

function create(zone, options)
	local Context = { zone=zone, options=options }
	lcd.setColor(CUSTOM_COLOR, Context.options.Color)
	return Context
end

function Calc_Headspeed(Context)

	RPM = getValue(Context.options.RPM)
	ThrPrc = getValue(Context.options.Throttle)
	
	if(RPM == nil) then
		return
	end
	
	if(ThrPrc == nil) then
		return
	end
	
	GearRatio = math.floor((Context.options.Maingear / Context.options.Pinion) * 100 + 0.5) / 100
	
	HeadspeedRPM = RPM / GearRatio

	if HeadspeedRPM > 5000 then
		HeadspeedRPM = 5000
	elseif HeadspeedRPM < 0 then
		HeadspeedRPM = 0
	end
	
	-- Recalculate Throttle range to %, Ranges are from -1024 - 1024, total 2048, divided by 100
	ThrPrc = (1024 + ThrPrc) / 20.48
	ThrPrc = round(ThrPrc)

	if(MaxRPM == nil) then
		MaxRPM = 0
	else
		if HeadspeedRPM > MaxRPM then
			MaxRPM = HeadspeedRPM
		end
	end

-- Screen zone selection

-- Note: A lot of screensizes have to be done at the moment

	-- Zone size: 390x172 & 460x207 & 460x252
	if Context.zone.w > 380 and Context.zone.h > 160 then

	-- Zone size: 225x207 & 225x252
	elseif Context.zone.w > 220 and Context.zone.h > 200 then

	-- Zone size: 225x98 & 225x121
	elseif Context.zone.w > 220 and Context.zone.h > 90 then

		if Context.options.Shadow == 1 then
			lcd.drawText(Context.zone.x, Context.zone.y, round(HeadspeedRPM) .. "  rpm" , DBLSIZE + CUSTOM_COLOR)
		else
			lcd.drawText(Context.zone.x, Context.zone.y, round(HeadspeedRPM) .. "  rpm" , DBLSIZE + CUSTOM_COLOR + SHADOWED)
		end

		lcd.drawText(Context.zone.x, Context.zone.y + 55, "Throttle: " .. round(ThrPrc).."%" , TEXT_COLOR)
		
	-- Zone size: 180x70
	elseif Context.zone.w == 180 and Context.zone.h == 70 then

		---lcd.drawText(Context.zone.x, Context.zone.y, "  Headspeed  ", INVERS)
		
		if Context.options.Shadow == 1 then
			lcd.drawText(Context.zone.x, Context.zone.y, round(HeadspeedRPM) .. "  rpm" , DBLSIZE + CUSTOM_COLOR)
		else
			lcd.drawText(Context.zone.x, Context.zone.y, round(HeadspeedRPM) .. "  rpm" , DBLSIZE + CUSTOM_COLOR + SHADOWED)
		end

		lcd.drawText(Context.zone.x, Context.zone.y + 55, "Throttle: " .. round(ThrPrc).."%" , TEXT_COLOR)
		lcd.drawText(Context.zone.x, Context.zone.y + 40, "Max: " .. round(MaxRPM).."  rpm", TEXT_COLOR)
		
	-- Zone size: 192x152
	elseif Context.zone.w == 192 and Context.zone.h == 152 then

	
	-- Zone size: 160x32
	elseif Context.zone.w == 160 and Context.zone.h == 32 then
		

	end

end

-- Rounds numbers up or down
function round(n)
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end


function update(Context, options)
	Context.options = options
	Context.back = nil
end

function refresh(Context)
	Calc_Headspeed(Context)
end

return { name="Headspeed", options=options, create=create, update=update, refresh=refresh }

