local success_mason, mason = pcall(require, "mason")
if not success_mason then
  return
end

mason.setup()
require("user.lsp.handlers").setup()
