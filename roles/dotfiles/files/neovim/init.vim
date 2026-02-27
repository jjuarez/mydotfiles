" Compatibility shim: delegate to Lua config.
if filereadable(expand('~/.config/nvim/init.lua'))
  execute 'luafile' fnameescape(expand('~/.config/nvim/init.lua'))
endif
