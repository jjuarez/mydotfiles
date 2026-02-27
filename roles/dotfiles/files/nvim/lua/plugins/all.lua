-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end

return {
  -- add TComment
  { "tomtom/tcomment_vim" },

  -- Configure LazyVim to load gruvbox
  {
    "numToStr/Comment.nvim",
    opts = {
      -- add custom options here
    },
  },

  -- 
  "folke/tokyonight.nvim",
  opts = {
    transparent = true,
    styles = {
      sidebars = "transparent",
      floats   = "transparent",
    }
  }
}
