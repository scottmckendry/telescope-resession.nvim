local telescope = require("telescope")

local config = require("telescope._extensions.resession.config")
local picker = require("telescope._extensions.resession.picker")

return telescope.register_extension({
    setup = config.setup,
    exports = { resession = picker.resession_picker },
})
