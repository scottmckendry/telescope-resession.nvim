local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local themes = require("telescope.themes")
local utils = require("telescope._extensions.resession.utils")

local M = {}

-- TODO: add mapping to delete sessions

--- Load the selected session
---@param prompt_bufnr number
function M.load_session(prompt_bufnr)
    local opts = require("telescope._extensions.resession.config").opts
    local session = action_state.get_selected_entry()
    local encoded = utils.encode_session(session[1], opts)
    actions.close(prompt_bufnr)
    require("resession").load(encoded, { dir = "dirsession" })
end

--- Render the session picker
function M.resession_picker()
    local opts = require("telescope._extensions.resession.config").opts
    local dropdown = themes.get_dropdown({})
    local resession_opts = {
        prompt_title = "Find session",
        finder = require("telescope.finders").new_table({
            results = utils.get_results(opts),
        }),

        attach_mappings = function(_, map)
            map("i", "<CR>", M.load_session)
            map("n", "<CR>", M.load_session)
            return true
        end,

        sorter = sorters.get_fzy_sorter(),
    }

    return pickers.new(dropdown, resession_opts):find()
end

return M
