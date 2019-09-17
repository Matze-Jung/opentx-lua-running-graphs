local function run(event)
    local rssi, alarm_low, alarm_crit = getRSSI()

    lcd.clear()

    -- tx battery voltage
    local format = 0
    if getValue("tx-voltage") <= 0 then
        format = format+BLINK
    end
    lcd.drawText(2, 1, "TX BAT", format)
    lcd.drawNumber(lcd.getLastPos() + 6, 1, getValue("tx-voltage")*100, PREC2+format)
    lcd.drawText(lcd.getLastPos() + 1, 1, "V", format)
    local settings = getGeneralSettings()
    local percent =  math.floor(((getValue("tx-voltage")-settings.battMin) * 100 / (settings.battMax-settings.battMin)) + 0.5)
    if percent <= 0 then percent = 0 end

    lcd.drawGauge(2, 10, LCD_W-4 , 13, percent, 100)

    if percent < 10 then
        percent = "  "..percent
    elseif percent < 100 then
        percent = " "..percent
    end
    lcd.drawText(LCD_W-20, 1, percent.."%", format)

    -- RSSI sensor
    format = 0
    if rssi <= alarm_crit then
        format = format+BLINK
    end
    lcd.drawText(2, 27, "RSSI", format)
    lcd.drawNumber(lcd.getLastPos() + 7, 27, rssi, format)
    lcd.drawText(lcd.getLastPos(), 27, "dB", format)

    local avrg = math.floor(getGraphAverage(1) + 0.5)
    if avrg < 10 then avrg = " "..avrg end
    lcd.drawText(LCD_W-54, 27, "AVRG", 0)
    lcd.drawText(lcd.getLastPos() + 6, 27, avrg, 0)
    lcd.drawText(lcd.getLastPos(), 27, "dB", 0)


    createGraph(1, {
        src=function() local rssi = getRSSI() return rssi end,
        x=13,
        y=36,
        w=LCD_W-16,
        h=27,
        speed=200,
        min=alarm_crit, max=100,
        crit=alarm_low,
    })
    lcd.drawText(2, 36, "99", SMLSIZE)
    lcd.drawText(2, 56, alarm_crit, SMLSIZE)
end

return { run=run }
