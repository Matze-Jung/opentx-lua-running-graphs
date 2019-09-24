local function run(event)
    lcd.clear()

    local percent = (getValue("thr") + 1000) * 100 / 2000
    if percent < 0 then percent = 0 end
    if percent > 100 then percent = 100 end

    lcd.drawFilledRectangle(0, 0, LCD_W, 8)
    lcd.drawText(2, 1, "THR", SMLSIZE+INVERS)
    lcd.drawNumber(lcd.getLastPos() + 3, 1, percent, SMLSIZE+INVERS)
    lcd.drawText(lcd.getLastPos(), 1, "%", SMLSIZE+INVERS)
    createGraph(2, {
        src=77,
        x=18,
        y=10,
        w=LCD_W-18-2,
        h=19,
        speed=50,
        min=-1000,
        max=1000,
        style=SOLID
    })
    lcd.drawText(2, 9, "max", SMLSIZE)
    lcd.drawText(3, 23, "min", SMLSIZE)

    percent = (getGraphAverage(2) + 1000) * 100 / 2000
    if percent < 0 then percent = 0 end
    if percent > 100 then percent = 100 end

    lcd.drawFilledRectangle(0, 32, LCD_W, 8)
    lcd.drawText(2, 33, "THR AVRG", SMLSIZE+INVERS)
    lcd.drawNumber(lcd.getLastPos() + 3, 33, percent, SMLSIZE+INVERS)
    lcd.drawText(lcd.getLastPos(), 33, "%", SMLSIZE+INVERS)
    createGraph(3, {
        src=function() return getGraphAverage(2) end,
        x=18,
        y=42,
        w=LCD_W-18-2,
        h=19,
        speed=50,
        min=-1000,
        max=1000,
        style=DOTTED
    })
    lcd.drawText(2, 41, "max", SMLSIZE)
    lcd.drawText(3, 55, "min", SMLSIZE)
end

return { run = run }
