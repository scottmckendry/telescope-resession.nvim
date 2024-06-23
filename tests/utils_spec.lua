local utils = require("telescope._extensions.resession.utils")

describe("apply_substitutions", function()
    it("should apply substitutions to a session string", function()
        local session = "C__Users_user_AppData_Local_nvim"
        local substitutions = utils.internal_substitutions
        local result = utils.apply_substitutions(session, substitutions, true)
        assert.are.same("C:/Users/user/AppData/Local/nvim", result)
    end)

    it("should apply substitutions in reverse to a session string", function()
        local session = "C:/Users/user/AppData/Local/nvim"
        local substitutions = utils.internal_substitutions
        local result = utils.apply_substitutions(session, substitutions)
        assert.are.same("C__Users_user_AppData_Local_nvim", result)
    end)

    it("should apply substitutions to a session string with user substitutions", function()
        local session = "C:/Users/user/AppData/Local/nvim"
        local substitutions = {
            { find = "C:/", replace = "D:/" },
            { find = "nvim", replace = "neovim" },
        }
        local result = utils.apply_substitutions(session, substitutions)
        assert.are.same("D:/Users/user/AppData/Local/neovim", result)
    end)
end)

describe("encode_session", function()
    it("should encode a session string", function()
        local session = "D:/Users/user/AppData/Local/neovim"
        local opts = { path_substitutions = { { find = "C:/", replace = "D:/" } } }
        local result = utils.encode_session(session, opts)
        assert.are.same("C__Users_user_AppData_Local_neovim", result)
    end)
end)

describe("decode_sessions", function()
    it("should decode a list of session strings", function()
        local sessions = { "C__Users_user_AppData_Local_neovim" }
        local opts = { path_substitutions = { { find = "C:/", replace = "D:/" } } }
        local result = utils.decode_sessions(sessions, opts)
        assert.are.same({ "D:/Users/user/AppData/Local/neovim" }, result)
    end)
end)
