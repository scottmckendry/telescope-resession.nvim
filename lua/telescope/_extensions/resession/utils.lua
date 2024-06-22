local M = {}
local internal_substitutions = {
    { find = ":/", replace = "__" },
    { find = "/", replace = "_" },
}

--- Apply a list of substitutions to a path/session string
--- @param path string The path/session string to apply the substitutions to
--- @param substitutions substitution[]? The list of substitutions to apply
--- @param reverse? boolean Whether to apply the substitutions in reverse, i.e. replace the replace string with the find string
M.apply_substitutions = function(path, substitutions, reverse)
    reverse = reverse or false

    if not substitutions then
        return path
    end

    for _, substitution in ipairs(substitutions) do
        if reverse then
            path = path:gsub(substitution.replace, substitution.find)
        else
            path = path:gsub(substitution.find, substitution.replace)
        end
    end
    return path
end

--- Encode a session string in the format used by resession
--- @param session_str string The session string to encode
--- @param opts config telescope-resession configuration
--- @return string The encoded session string
M.encode_session = function(session_str, opts)
    local user_substitutions = opts.path_substitutions or {}
    session_str = M.apply_substitutions(session_str, user_substitutions, true)
    session_str = M.apply_substitutions(session_str, internal_substitutions)

    return session_str
end

--- Decode a list of session strings in the format used by resession to a friendlier format
--- @param sessions string[] The list of session strings to decode. Usually the output of resession.list()
--- @param opts config telescope-resession configuration
--- @return string[] The decoded session strings
M.decode_sessions = function(sessions, opts)
    for i, session in ipairs(sessions) do
        session = M.apply_substitutions(session, internal_substitutions, true)
        session = M.apply_substitutions(session, opts.path_substitutions)
        sessions[i] = session
    end
    return sessions
end

--- Get a list of sessions from resession
--- @param opts config telescope-resession configuration
--- @return string[] The list of sessions
M.get_sessions = function(opts)
    return require("resession").list({ dir = opts.dir })
end

--- Get a list of sessions from resession and decode them
--- @param opts config telescope-resession configuration
--- @return string[] The list of decoded sessions
M.get_results = function(opts)
    return M.decode_sessions(M.get_sessions(opts), opts)
end

return M
