-- Thème Catppuccin, repris à l'identique d'Omarchy (themes/catppuccin/neovim.lua)
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-nvim",
    },
  },
}
