# 🔭 pick-resession.nvim

A telescope extension that adds a session picker to the wonderful [resession.nvim](https://github.com/stevearc/resession.nvim) plugin.

![image](https://github.com/scottmckendry/pick-resession.nvim/assets/39483124/93fb9c3d-1345-4f74-a37d-b8e520116362)

## 📦 Extension Installation

```lua
{
    "nvim-telescope/telescope.nvim",
    dependencies = { "scottmckendry/pick-resession.nvim" },
    config = function()
        telescope.setup({
            -- Other telescope config...
            extensions = {
                resession = {
                        prompt_title = "Find Sessions", -- telescope prompt title
                        dir = "session", -- directory where resession stores sessions
                    },
                },
            },
        })
    end,
}
```

## ⏪ Recommended Resession Configuration

```lua
return {
    "stevearc/resession.nvim",
    config = function()
        local resession = require("resession")
        resession.setup({})

        -- Automatically save sessions on by working directory on exit
        vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = function()
                resession.save(vim.fn.getcwd(), { notify = true })
            end,
        })

        -- Automatically load sessions on startup by working directory
        vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
                -- Only load the session if nvim was started with no args
                if vim.fn.argc(-1) == 0 then
                    resession.load(vim.fn.getcwd(), { silence_errors = true })
                end
            end,
            nested = true,
        })
    end,
}
```

## 🚀 Usage

Vim command:

```vim
:Telescope resession
```

Lua:

```lua
require("telescope").extensions.resession.resession()
```

**Prompt Key Maps:**

| Mode           | Key Mapping | Description                 |
| -------------- | ----------- | --------------------------- |
| Normal, Insert | `<CR>`      | Load the selected session   |
| Normal, Insert | `<C-d>`     | Delete the selected session |

## 🎨 Customization

```lua
extensions = {
    resession = {
        prompt_title = "Your custom prompt title",

        -- Apply custom path substitutions to the session paths
        path_substitutions = {
            { find = "/home/username", replace = "🏠" },
        },
    },
},
```
