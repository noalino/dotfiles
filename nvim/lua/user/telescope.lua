local success, telescope = pcall(require, "telescope")
if not success then
  return
end

telescope.setup({
  extensions = {
    fzf = {
      fuzzy = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
})

telescope.load_extension("fzf")
