-- Pulling Anthropic keys
-- local key_location = "~/Documents/auth.json"
-- local anthropic_key_name = "ANTHROPIC_API_KEY"
--
-- local function get_key(key_name)
--     local key_extraction_cmd = string.format("jq '.%s' %s", key_name, key_location)
--     local handle = io.popen(key_extraction_cmd)
--     if handle then
--         local output = handle:read("*a")
--         handle:close()
--         return output
--     else
--         return nil, "Error fetching keys for " .. key_name .. " within " .. key_location
--     end
-- end
-- vim.env.ANTHROPIC_API_KEY = get_key(anthropic_key_name)

local opts = {
    ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
    provider = "claude",
    auto_suggestions_provider = "claude",
    claude = {
        endpoint = "https://api.anthropic.com",
        -- api_key_name = "cmd:jq \'.ANTHROPIC_API_KEY\' ~/Documents/auth.json",
        model = "claude-3-5-sonnet-20241022",
        temperature = 0,
        max_tokens = 4096,
    },
    behaviour = {
        auto_suggestions = false, -- Experimental stage
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
    },
    mappings = {
        --- @class AvanteConflictMappings
        diff = {
            ours = "co",
            theirs = "ct",
            all_theirs = "ca",
            both = "cb",
            cursor = "cc",
            next = "]x",
            prev = "[x",
        },
        suggestion = {
            accept = "<M-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
        },
        jump = {
            next = "]]",
            prev = "[[",
        },
        submit = {
            normal = "<CR>",
            insert = "<C-s>",
        },
        sidebar = {
            apply_all = "A",
            apply_cursor = "a",
            switch_windows = "<Tab>",
            reverse_switch_windows = "<S-Tab>",
        },
    },
    hints = { enabled = true },
    windows = {
        ---@type "right" | "left" | "top" | "bottom"
        position = "right", -- the position of the sidebar
        wrap = true, -- similar to vim.o.wrap
        width = 40, -- default % based on available width
        sidebar_header = {
            enabled = true, -- true, false to enable/disable the header
            align = "center", -- left, center, right for title
            rounded = true,
        },
        input = {
            prefix = "> ",
            height = 8, -- Height of the input window in vertical layout
        },
        edit = {
            border = "rounded",
            start_insert = true, -- Start insert mode when opening the edit window
        },
        ask = {
            floating = true, -- Open the 'AvanteAsk' prompt in a floating window
            start_insert = true, -- Start insert mode when opening the ask window
            border = "rounded",
            ---@type "ours" | "theirs"
            focus_on_apply = "ours", -- which diff to focus after applying
        },
    },
    highlights = {
        ---@type AvanteConflictHighlights
        diff = {
            current = "DiffText",
            incoming = "DiffAdd",
        },
    },
    --- @class AvanteConflictUserConfig
    diff = {
        autojump = true,
        ---@type string | fun(): any
        list_opener = "copen",
        --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
        --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
        --- Disable by setting to -1.
        override_timeoutlen = 500,
    },
}

return {
    {
        "yetone/avante.nvim",
        event = "VeryLazy",
        lazy = false,
        version = false, -- set this to "*" if you want to always pull the latest change, false to update on release
        opts = opts,
        build="make BUILD_FROM_SOURCE=true",
        -- build="make",
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- Recommended Settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        -- use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
        keys = {
            { "<leader>at", "<cmd>AvanteToggle<cr>", mode={"n", "v"}, desc="Toggle Avante Window" },
            { "<F6>", "<cmd>AvanteToggle<cr>", mode={"n", "v", "i"}, desc="Toggle Avante Window" },
        }
    },
    {
        dir = "/home/amey/workspace/neovim/geno.nvim/"
    },
}
