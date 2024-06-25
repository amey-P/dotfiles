local config = {
    workspaces = {
        personal = "~/Documents/notes/personal",
        study = "~/Documents/notes/study",
        cfa = "~/Documents/notes/cfa",
        notes = "~/Documents/notes/notes",
    },
    default_workspace = "notes",
}

require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.ui.calendar"] = {},
        ["core.integrations.telescope"] = {},
        ["core.concealer"] = {
            config = {
                folds = false,
            }
        },
        ["core.completion"] = {
            config = {
                engine = "nvim-cmp",
            }
        },
        ["core.dirman"] = {
            config = config
        },
        ["core.journal"] = {
            config = {
                journal_folder = "journal",
                strategy = "flat"
            }
        },
        ["core.summary"] = {},
        ["core.qol.todo_items"] = {
            config = {
                create_todo_parents = true
            }
        },
        ["core.export"] = {},
        ["core.export.markdown"] = {
            config = {
                extensions = "all"
            }
        }
    }
}

local neorg_callbacks = require("neorg.core.callbacks")

neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
        n = { -- Bind keys in normal mode
            { "<C-s>", "core.integrations.telescope.find_linkable" },
        },

        i = { -- Bind in insert mode
            { "<C-l>", "core.integrations.telescope.insert_link" },
        },
    }, {
        silent = true,
        noremap = true,
    })
end)

local M = {}

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

M.switch_workspace = function()
    local workspaces = config.workspaces
    local workspace_names = {}
    for workspace_name, _ in pairs(workspaces) do
        table.insert(workspace_names, workspace_name)
    end
    opts = require("telescope.themes").get_dropdown(opts)
    pickers.new(opts, {
        prompt_title = "Switch Workspace",
        finder = finders.new_table {
            results = workspace_names,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry,
                    ordinal = entry,
                }
            end,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<CR>", function()
                local selection = require("telescope.actions.state").get_selected_entry()
                print(selection.value)
                require("telescope.actions").close(prompt_bufnr)
                vim.cmd("Neorg workspace " .. selection.value)
            end)
            return true
        end,
    }):find()
end

-- Search and add Category to Note
-- 1. Search workspace files and list all categories already added
-- 2. Summarize Using LLM and suggest categories

-- Add Links

return M
