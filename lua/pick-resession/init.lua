local M = {}
local ok, picker = pcall(require, "snacks.picker")
if not ok then
    return
end

--- @class pickresession.Config
--- @field prompt_title? string
--- @field layout? snacks.picker.layout.Config | "default" | "dropdown" | "ivy" | "select" | "vscode"
--- @field default_icon? { icon: string, highlight: string }
--- @field path_icons? { match: string, icon: string, highlight: string }
M.config = {
    prompt_title = "Pick Session",
    layout = "default",
    default_icon = { icon = " ", highlight = "Directory" },
    path_icons = {},
}

local function apply_icon(display_value)
    for _, icon in ipairs(M.config.path_icons) do
        if display_value:find(icon.match) then
            return icon, display_value:gsub(icon.match, "")
        end
    end
    return M.config.default_icon, display_value
end

local function format_session_item(item)
    local icon, display_value = apply_icon(item.display_value)
    return {
        { icon.icon, icon.highlight },
        { display_value, "Normal" },
    }
end

local function generate_sessions()
    local sessions = {}
    for idx, session in ipairs(require("resession").list()) do
        local formatted = session:gsub("__", ":/"):gsub("_", "/")
        --- @type snacks.picker.Item
        sessions[#sessions + 1] = {
            score = 0,
            text = session,
            value = session,
            idx = idx,
            display_value = formatted,
            file = formatted,
        }
    end
    return sessions
end

M.pick = function()
    picker.pick({
        title = M.config.prompt_title,
        finder = generate_sessions,
        layout = M.config.layout,
        format = format_session_item,
        confirm = function(self, item)
            self:close()
            require("resession").load(item.text)
        end,
        actions = {
            delete_session = function(self, item)
                require("resession").delete(item.text, { notify = false })
                self:find({
                    refresh = true,
                })
            end,
        },
        win = {
            input = {
                keys = {
                    ["<C-d>"] = { "delete_session", mode = { "n", "i" }, desc = "Delete session" },
                },
            },
        },
    })
end

--- @param opts pickresession.Config
M.setup = function(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

return M
