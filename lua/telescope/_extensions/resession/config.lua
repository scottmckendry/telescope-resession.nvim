local M = {}

--- @class substitution
--- @field find string The string to find
--- @field replace string The string to replace it with

--- @class config
--- @field path_substitutions? substitution[] A list of substitutions to apply to paths
M.defaults = {
    prompt_title = "Find Session",
    dir = "session",
    path_substitutions = {},
}

M.opts = {}

function M.setup(opts)
    opts = opts or {}
    M.opts = vim.tbl_deep_extend("force", M.defaults, opts)
end

return M
