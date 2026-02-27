-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*",
  callback = function(args)
    local ext = vim.fn.fnamemodify(args.file, ":e")
    if ext == "" then
      return
    end

    local template = template_dir .. "/templates" .. ext
    if vim.api.nvim_buf_line_count(args.buf) ~= 1 then
      return
    end

    local first = vim.api.nvim_bug_get_lines(args.buf, 0, 1, false)[1]
    if first ~= "" then
      return
    end

    -- Read the template
    vim.cmd("silent 0read " .. vim.fn.fnameescape(template))

    -- Remove the extra blank first line
    vim.cmd("sinlent 1delete _")

    -- Put cursor at end
    vim.cmd("normal! G")
  end,
})
