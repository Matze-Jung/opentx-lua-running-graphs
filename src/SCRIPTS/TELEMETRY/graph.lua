local function run(event)
    lcd.clear()

    local percent = (getValue("thr") + 1000) * 100 / 2000
    if percent < 0 then percent = 0 end
    if percent > 100 then percent = 100 end

    lcd.drawFilledRectangle(0, 0, LCD_W, 8)
    lcd.drawText(2, 1, "THR", SMLSIZE+INVERS)
    lcd.drawNumber(lcd.getLastPos() + 3, 1, percent, SMLSIZE+INVERS)
    lcd.drawText(lcd.getLastPos(), 1, "%", SMLSIZE+INVERS)
    createGraph(4, {
        src=77,
        x=18,
        y=10,
        w=LCD_W-18-2,
        h=LCD_H-10-1,
        speed=25,
        min=-1000,
        max=1000,
        -- crit=350,
        -- lnStyle=SOLID,
        lnSize=2,
    })
    lcd.drawText(2, 9, "max", SMLSIZE)
    lcd.drawText(3, 55, "min", SMLSIZE)
end

return { run=run }
