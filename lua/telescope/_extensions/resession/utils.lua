local M = {}

--- Encode a session string in the format used by resession
--- @param session_str string The session string to encode
--- @return string The encoded session string
M.encode_session = function(session_str)
    session_str = session_str:gsub(":\\", "__"):gsub("\\", "_")
    return session_str
end

--- Decode a list of session strings in the format used by resession to a friendlier format
--- TODO: Test in linux with different paths
--- TODO: Support path formatting options (e.g. relative paths) ✨
--- @param sessions string[] The list of session strings to decode. Usually the ouotput of resession.list()
--- @return string[] The decoded session strings
M.decode_sessions = function(sessions)
    for i, session in ipairs(sessions) do
        sessions[i] = session:gsub("__", ":\\"):gsub("_", "\\")
    end
    return sessions
end

--- Get a list of sessions from resession
--- @return string[] The list of sessions
M.get_sessions = function()
    return require("resession").list({ dir = "dirsession" })
end

--- Get a list of sessions from resession and decode them
--- @return string[] The list of decoded sessions
M.get_results = function()
    return M.decode_sessions(M.get_sessions())
end

return M
