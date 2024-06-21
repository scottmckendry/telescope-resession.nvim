local telescope = require("telescope")

return telescope.register_extension({
    exports = { resession = require("telescope._extensions.resession.picker").resession_picker },
})
