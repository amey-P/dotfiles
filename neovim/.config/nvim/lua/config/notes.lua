local config = require("config.globals").config

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values

local switch_workspace = function(opts)
    opts = opts or {}
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
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            vim.cmd("Neorg workspace " .. selection[1])
          end)
          return true
        end,
    }):find()
end

vim.keymap.set("n", "<leader>nw", switch_workspace, { noremap = true })
