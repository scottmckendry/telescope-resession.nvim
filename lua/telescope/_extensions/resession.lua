local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local telescope = require("telescope")
local themes = require("telescope.themes")
local sorters = require("telescope.sorters")
local pickers = require("telescope.pickers")

local ok, _ = pcall(require, "telescope")
if not ok then
    error("This plugin requires telescope.nvim")
end

ok, _ = pcall(require, "resession")
if not ok then
    error("This plugin requires resession.nvim")
end

local function encode_session(session_str)
    return session_str:gsub(":\\", "__"):gsub("\\", "_")
end

local function decode_sessions(sessions)
    for i, session in ipairs(sessions) do
        sessions[i] = session:gsub("__", ":\\"):gsub("_", "\\")
    end
    return sessions
end

local function get_sessions()
    local sessions = require("resession").list({ dir = "dirsession" })
    return sessions
end

local function load_session(prompt_bufnr)
    local session = action_state.get_selected_entry()
    local encoded = encode_session(session[1])
    actions.close(prompt_bufnr)
    require("resession").load(encoded, { dir = "dirsession" })
end

local dropdown = themes.get_dropdown({})

local resession_opts = {
    prompt_title = "Find session",
    finder = require("telescope.finders").new_table({
        results = decode_sessions(get_sessions()),
    }),

    attach_mappings = function(_, map)
        map("i", "<CR>", load_session)
        map("n", "<CR>", load_session)
        return true
    end,

    sorter = sorters.get_generic_fuzzy_sorter(),
}

local function resession_picker()
    pickers.new(dropdown, resession_opts):find()
end

return telescope.register_extension({ exports = { resession = resession_picker } })
