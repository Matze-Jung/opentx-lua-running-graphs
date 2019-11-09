--[[ ** TELEMETRY SCREEN WIDGET **

  Draws a moving line graph from a given source.


  PLATFORM
    HORUS and relatives

    SCALING
      vert: scalable
      horiz: scalable

    OPTIONS [options.lua]
      UID: int
        - Systemwide unique graph ID

      Speed: int (optional, default 30)
        - Running speed in 100ths second intervals, means smaller is faster

      Min/Max: number
      - Largest/smallest possible value

      Source: number
        - Input sensor-ID

    PARAMETER [config.lua]
      lbl: string (optional)
        - Widgets label text at the top

      lblstyle: int (optional, default 0)
        - Set text attributes for label

      unit: string (optional)
        - Unit sign drawn behind the value
        - Set to "%", to output percent of 'src', calculated with 'min' and 'max'

      crit: number (optional)
        - If set, the line style is DOTTED below and SOLID above this value
        - The X-axis gets a mark at the values position

      lnStyle: int (optional, default SOLID - but DOTTED at 'min' or 'max' values)
        - Set to SOLID for a full solid line
        - Set to DOTTED for a dotted line

      lnSize: int (optional, default 1)
        - Set the line thickness in px

      p: table (optional, default [t=0, r=0, b=0, l=0])
         - Cell padding in px
           (top, right, bottom, left)
--]]

local options = assert(loadScript("/WIDGETS/Graph/options.lua"))()

local function create(zone, options)
    local cfg = assert(loadScript("/WIDGETS/Graph/config.lua"))()
    local core = assert(loadScript("/SCRIPTS/GRAPHS/graphs.lua"))()
    core.init()

    return { zone=zone, options=options, cfg=cfg, core=core }
end

local function update(wgt, options)
    wgt.options = options
    wgt.core.init(options.UID)

    return wgt
end

local function background(wgt)
    return wgt.core.run()
end

function refresh(wgt)
    local cfg = wgt.cfg

    wgt.core.run()

    if cfg.lbl then
        local val = getValue(wgt.options.Source)
        lcd.drawText(wgt.zone.x + 1, wgt.zone.y + 1, cfg.lbl .. "   " .. val .. (cfg.unit or ""), cfg.lblstyle)
        cfg.p.t = 21
    end

    createGraph(wgt.options.UID, {
        src=wgt.options.Source,
        x=wgt.zone.x + cfg.p.l,
        y=wgt.zone.y + cfg.p.t,
        w=wgt.zone.w - cfg.p.l - cfg.p.r,
        h=wgt.zone.h - cfg.p.t - cfg.p.b,
        speed=wgt.options.Speed,
        min=wgt.options.Min,
        max=wgt.options.Max,
        lnStyle=cfg.lnStyle,
        lnSize=cfg.lnSize,
        crit=cfg.crit
    })
end

return { name="THR Curve", options=options, create=create, update=update, background=background, refresh=refresh }
