local function run(event)
    local rssi, alarm_low, alarm_crit = getRSSI()

    lcd.clear()

    -- throttle range
    lcd.drawText(3, 5, "THR", SMLSIZE)
    lcd.drawText(lcd.getLastPos()+1, 5, "RNG", SMLSIZE)
    lcd.drawNumber(lcd.getLastPos()+2, 5, getValue("gvar9") > 0 and getValue("gvar9") or 100)
    lcd.drawText(lcd.getLastPos(), 5, "%", SMLSIZE)

    -- armed
    if getValue("ls4") > 0 then
        lcd.drawText(60, 4, "ARMED", BLINK)
    end

    -- timer one
    lcd.drawTimer(LCD_W-35, 2, getValue("timer1"), MIDSIZE)

    -- tx battery voltage
    local format = SMLSIZE
    if getValue("tx-voltage") <= 0 then
        format = format+BLINK
    end
    lcd.drawText(3, 17, "BAT  ", format)
    lcd.drawNumber(28, 17, getValue("tx-voltage")*100, PREC2+format)
    lcd.drawText(lcd.getLastPos(), 17, "V", format)
    local settings = getGeneralSettings()
    local percent =  math.floor(((getValue("tx-voltage")-settings.battMin) * 100 / (settings.battMax-settings.battMin)) + 0.5)
    if percent <= 0 then percent = 0 end

    lcd.drawGauge(3, 25, LCD_W-8 , 3, percent, 100)

    if percent < 10 then
        percent = "  "..percent
    elseif percent < 100 then
        percent = " "..percent
    end
    lcd.drawText(LCD_W-23, 17, percent.."%", format)

    -- RSSI sensor
    format = SMLSIZE
    if rssi <= alarm_crit then
        format = format+BLINK
    end
    lcd.drawText(3, 31, "RSSI  ", format)
    lcd.drawNumber(lcd.getLastPos(), 31, rssi, format)
    lcd.drawText(lcd.getLastPos(), 31, "dB", format)

    local avrg = math.floor(getGraphAverage(1) + 0.5)
    if avrg < 10 then avrg = " "..avrg end
    lcd.drawText(LCD_W-50, 31, "AVRG  ", SMLSIZE)
    lcd.drawText(lcd.getLastPos(), 31, avrg, SMLSIZE)
    lcd.drawText(lcd.getLastPos(), 31, "dB", SMLSIZE)


    createGraph(1, {
        src=function() local rssi = getRSSI() return rssi end,
        x=13,
        y=40,
        w=LCD_W-18-4,
        h=21,
        speed=100,
        min=alarm_crit, max=100,
        crit=alarm_low,
    })
    lcd.drawText(3, 40, "99", SMLSIZE)
    lcd.drawText(3, 56, alarm_crit, SMLSIZE)
end

return { run=run }
