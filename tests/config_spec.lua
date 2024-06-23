local config = require("telescope._extensions.resession.config")

describe("setup", function()
    it("should populate an empty opts table with defaults", function()
        config.setup()
        assert.are.same(config.opts, config.defaults)
    end)

    it("should keep user defined options", function()
        config.setup({ prompt_title = "New Title" })
        assert.are.same(config.opts.prompt_title, "New Title")
    end)
end)
