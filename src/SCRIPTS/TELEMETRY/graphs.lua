local function run(event)
    lcd.clear()

    local percent = (getValue("thr") + 1000) * 100 / 2000
    if percent < 0 then percent = 0 end
    if percent > 100 then percent = 100 end

    lcd.drawFilledRectangle(0, 0, LCD_W, 8)
    lcd.drawText(1, 1, "THR", SMLSIZE+INVERS)
    lcd.drawNumber(lcd.getLastPos() + 3, 1, percent, SMLSIZE+INVERS)
    lcd.drawText(lcd.getLastPos(), 1, "%", SMLSIZE+INVERS)
    createGraph(2, {
        src=77,
        x=18,
        y=9,
        w=LCD_W-19,
        h=22,
        speed=50,
        min=-1000,
        max=1000,
        lnStyle=SOLID
    })
    lcd.drawText(1, 8, "max", SMLSIZE)
    lcd.drawText(1, 24, "min", SMLSIZE)

    percent = (getGraphAverage(2) + 1000) * 100 / 2000
    if percent < 0 then percent = 0 end
    if percent > 100 then percent = 100 end

    lcd.drawFilledRectangle(0, 32, LCD_W, 8)
    lcd.drawText(1, 33, "THR AVRG", SMLSIZE+INVERS)
    lcd.drawNumber(lcd.getLastPos() + 3, 33, percent, SMLSIZE+INVERS)
    lcd.drawText(lcd.getLastPos(), 33, "%", SMLSIZE+INVERS)
    createGraph(3, {
        src=function() return getGraphAverage(2) end,
        x=18,
        y=41,
        w=LCD_W-19,
        h=22,
        speed=50,
        min=-1000,
        max=1000,
        lnStyle=DOTTED
    })
    lcd.drawText(1, 40, "max", SMLSIZE)
    lcd.drawText(1, 56, "min", SMLSIZE)
end

return { run = run }
