-- set your input condition to toggle (all graphs global)
return {
    pause = { func=function() return getValue("sa") > 100 end },
}
