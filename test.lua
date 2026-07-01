hl = {
  bind = function(...) print("BIND:", ...) end,
  dsp = setmetatable({}, {
    __index = function(t, k)
      return function(...) print("DSP CALLED:", k, ...) end
    end
  }),
  gesture = function() end
}
require("config.keybinds")
