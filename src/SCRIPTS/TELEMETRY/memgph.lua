-- NOTE:  Define global var MEMORY, typically anywhere near the end of the code cycle:
--        MEMORY = collectgarbage("count") * 1024

local function run(event)
    lcd.clear()

    lcd.drawFilledRectangle(0, 0, LCD_W, 8)
    lcd.drawText(1, 1, "MEM USED  "..(MEMORY or 0).."B", SMLSIZE+INVERS)
    lcd.drawNumber(lcd.getLastPos() + 18, 1, (MEMORY or 0) / 1024 * 100, PREC2+SMLSIZE+INVERS)
    lcd.drawText(lcd.getLastPos(), 1, "kB", SMLSIZE+INVERS)

    createGraph(6, {
        src=function() return MEMORY or 0 end,
        x=17,
        y=10,
        w=LCD_W-18,
        h=LCD_H-19,
        speed=100,
        min=25600,
        max=76800,
        crit=61440,
        lnSize=1,
    })
    lcd.drawText(1, 10, "75K", SMLSIZE)
    lcd.drawText(1, LCD_H-16, "25K", SMLSIZE)

    lcd.drawFilledRectangle(0, LCD_H-8, LCD_W, 8)
    lcd.drawText(1, LCD_H-7,
      "AVRG  " ..math.floor(getGraphAverage(6) + 0.5).."B      MAX  "..(getGraphRange(6).max or 0).."B",
      SMLSIZE+INVERS
    )
end

return { run = run }
