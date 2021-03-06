--[[ ** TELEMETRY SCREEN WIDGET **

  Draws a moving line graph from a given source.

  NOTE: Make shure to have the opentx-lua-running-graphs package installed
        and the graphs-script running. https://github.com/Matze-Jung/opentx-lua-running-graphs


  PLATFORM
    X7, X9 and relatives

  SCALING
    vert: scalable
    horiz: scalable

  PARAMETER
    zone: table [x, y, w, h]
      - Location on display in px
        (x-pos, y-pos, width, height)

    event: int
      - User event

    opts: table
      - Configurations

        uid: int
          - Systemwide unique graph ID

        src: function or sensor-ID string/number
          - Data source

        max/min: number
          - Largest/smallest possible value

        speed: int (optional, default 75)
          - Running speed in 100ths second intervals, means smaller is faster

        lnStyle: int (optional, default SOLID - but DOTTED at 'min' or 'max' values)
          - Set to SOLID for a full solid line
          - Set to DOTTED for a dotted line

        lnSize: int (optional, default 1)
          - Set the line thickness in px

        crit: number (optional)
          - If set, the line style is DOTTED below and SOLID above this value
          - The X-axis gets a mark at the values position

        lblmax/lblmin: string (optional)
          - Label at X-axis top/bottom
          - Use padding left to adjust the spacing

        lbl: string (optional)
          - Widgets label text at the top

        unit: string (optional)
          - Unit sign drawn behind the value
          - Set to "%", to output percent of 'src', calculated with 'min' and 'max'

        m: table (optional, default [t=0, r=0, b=0, l=0])
           - Cell margin in px
             (top, right, bottom, left)

        p: table (optional, default [t=0, r=1, b=2, l=1])
           - Cell padding in px
             (top, right, bottom, left)
--]]

local function graphWidget(zone, event, opts)
    local p = { t=0,r=1,b=2,l=1 }

    if opts and opts.p then
        for i, x in pairs(opts.p) do
            p[i] = x
        end
    end

    local z = calcWidgetZone(zone, m, opts.m or false)
    local val = type(opts.src) == "function"
        and opts.src()
        or getValue(opts.src)

    if opts.unit == "%" then
        val = (val + opts.max) * 100 / (opts.max-opts.min)
        if val < 0 then val = 0 end
        if val > 100 then val = 100 end
    end

    if opts.lbl then
        lcd.drawFilledRectangle(z.x, z.y, z.w, 8)
        lcd.drawText(z.x + 1, z.y + 1, opts.lbl, SMLSIZE+INVERS)
        lcd.drawNumber(lcd.getLastPos() + 5, z.y + 1, val, SMLSIZE+INVERS)
        lcd.drawText(lcd.getLastPos(), z.y + 1, opts.unit or "", SMLSIZE+INVERS)
        z.y = z.y + 9
        z.h = z.h - 8
    end

    createGraph(opts.uid, {
        src=opts.src,
        x=p.l + z.x,
        y=p.t + z.y,
        w=z.w - p.l - p.r,
        h=z.h - p.t - p.b,
        speed=opts.speed or 75,
        min=opts.min,
        max=opts.max,
        lnStyle=opts.lnStyle,
        lnSize=opts.lnSize,
        crit=opts.crit
    })
    lcd.drawText(z.x + 1, p.t + z.y, opts.lblmax or "", SMLSIZE)
    lcd.drawText(z.x + 1, z.y + z.h - p.b - 7, opts.lblmin or "", SMLSIZE)
end

return { run=graphWidget }
