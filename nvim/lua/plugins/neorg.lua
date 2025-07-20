-- return {
--     "nvim-neorg/neorg",
--     lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
--     version = "*", -- Pin Neorg to the latest stable release
--     config = true,
-- }
vim.g.maplocalleader = ","
-- vim.keymap.set("n", "<LocalLeader>nn", "<Plug>(neorg.dirman.new-note)", {})
return {
        "nvim-neorg/neorg",
        build = ":Neorg sync-parsers",
        opts = {
            load = {
                ["core.defaults"] = {}, -- Loads default behaviour
                ["core.export.markdown"] = {},
                ["core.latex.renderer"] = { 
                    config = {
                        render_on_enter = true,
                    }, 
                },
                ["core.concealer"] = {}, -- Adds pretty icons to your documents
                ["core.keybinds"] = {}, -- Adds pretty icons to your documents
                ["core.dirman"] = { -- Manages Neorg workspaces
                    config = {
                        workspaces = {
                            notes = "~/notes",
                        },
                        default_workspace = "notes",
                    },
                },
            },
        },
        dependencies = {
            { "nvim-lua/plenary.nvim", },
            -- {
            --     -- YOU ALMOST CERTAINLY WANT A MORE ROBUST nvim-treesitter SETUP
            --     -- see https://github.com/nvim-treesitter/nvim-treesitter
            --     "nvim-treesitter/nvim-treesitter",
            --     opts = {
            --         auto_install = true,
            --         highlight = {
            --             enable = true,
            --             additional_vim_regex_highlighting = false,
            --         },
            --     },
            --     config = function(_,opts)
            --         require('nvim-treesitter.configs').setup(opts)
            --     end
            -- },
            -- { "folke/tokyonight.nvim", config=function(_,_) vim.cmd.colorscheme "tokyonight-storm" end,},
        },
    }
