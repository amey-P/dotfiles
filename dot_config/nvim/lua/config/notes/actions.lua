local M = {}

local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local config = require('config.notes.config')
local utils = require('config.notes.utils')

-- --- Capture TODO ---

function M.capture_todo()
    local todo_file = config.capture.todo.file
    local buf, win = utils.open_file_popup(todo_file, "Capture Todo")
    
    -- Ensure we are at the end of the buffer
    local line_count = vim.api.nvim_buf_line_count(buf)
    
    -- Check if we need to add newlines for spacing
    local last_line = vim.api.nvim_buf_get_lines(buf, line_count - 1, line_count, false)[1]
    if last_line and last_line ~= "" then
        vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, { "", "" })
        line_count = line_count + 2
    end
    
    vim.api.nvim_win_set_cursor(win, { line_count, 0 })

    local todo_snippet = ls.snippet("todo_capture", fmt(
        [[
    ## {}
    - [ ] {}
    - Captured: {}
    - Tags: #inbox {}
    ]],
        {
            ls.insert_node(1, "Task Title"),
            rep(1),
            ls.function_node(utils.get_date),
            ls.insert_node(2),
        }
    ))
    
    ls.snip_expand(todo_snippet)
end

function M.show_todos()
    local todo_file = config.capture.todo.file
    utils.open_file_popup(todo_file, "Inbox")
end

-- --- Capture Notes (Epiphany / Research) ---

local function get_research_topics()
    local research_folder = vim.fn.expand(config.capture.research.folder)
    local topics = {}
    
    -- Get all directories in research folder
    local dirs = vim.fn.globpath(research_folder, "*/", 0, 1)
    
    for _, dir in ipairs(dirs) do
        -- Extract just the directory name
        local topic = vim.fn.fnamemodify(dir, ":h:t")
        table.insert(topics, topic)
    end
    
    return topics
end

local function create_note_file(title, template_name, template_fmt, target_dir)
    if not title or title == "" then
        vim.notify("Title is required!", vim.log.levels.ERROR)
        return
    end

    local notes_dir = vim.fn.expand(target_dir or config.capture.note.folder) .. "/"
    local filename = utils.sanitize_filename(title)
    local filepath = notes_dir .. filename

    utils.ensure_dir(notes_dir)
    vim.cmd("edit " .. filepath)

    local snippet = ls.snippet(template_name, template_fmt)
    ls.snip_expand(snippet)
end

function M.create_epiphany(title)
    local template = fmt(
        [[
    ---
    title: {}
    date: {}
    type: epiphany
    tags: [epiphany, {}]
    ---

    # {}

    > {}

    ## {}
    {}
    ]],
        {
            ls.text_node(title),
            ls.function_node(utils.get_date),
            ls.insert_node(1, "topic"),
            ls.text_node(title),
            ls.insert_node(2, "One sentence summary"),
            ls.insert_node(3, "The Spark / Context"),
            ls.insert_node(4),
        }
    )
    create_note_file(title, "epiphany_auto", template)
end

function M.create_research_note(title)
    local topics = get_research_topics()
    local options = { "Create New Topic" }
    for _, t in ipairs(topics) do
        table.insert(options, t)
    end

    local process_topic = function(topic)
        if not topic or topic == "" then return end
        
        local research_folder = config.capture.research.folder
        local target_dir = research_folder .. "/" .. topic
        
        local template = fmt(
            [[
        ---
        title: {}
        date: {}
        type: research
        tags: [research, {}]
        ---

        # {}

        > {}

        * **Source:** {}

        ## {}
        {}
        ]],
            {
                ls.text_node(title),
                ls.function_node(utils.get_date),
                ls.insert_node(1, topic),
                ls.text_node(title),
                ls.insert_node(2, "Brief summary"),
                ls.insert_node(3),
                ls.insert_node(4, "Key Concept"),
                ls.insert_node(5),
            }
        )
        create_note_file(title, "research_auto", template, target_dir)
    end

    local has_telescope, pickers = pcall(require, "telescope.pickers")
    if not has_telescope then
        vim.ui.select(options, { prompt = "Select Research Topic:" }, function(choice)
            if not choice then return end
            if choice == "Create New Topic" then
                vim.ui.input({ prompt = "New Topic Name: " }, process_topic)
            else
                process_topic(choice)
            end
        end)
        return
    end

    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"
    local themes = require "telescope.themes"

    pickers.new(themes.get_dropdown({}), {
        prompt_title = "Select Research Topic",
        finder = finders.new_table {
            results = options
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local choice = selection[1]

                if choice == "Create New Topic" then
                    vim.ui.input({ prompt = "New Topic Name: " }, process_topic)
                else
                    process_topic(choice)
                end
            end)
            return true
        end,
    }):find()
end

function M.browse_research()
    local has_telescope, builtin = pcall(require, "telescope.builtin")
    local research_folder = vim.fn.expand(config.capture.research.folder)

    -- Ensure directory exists before browsing
    utils.ensure_dir(research_folder)

    if has_telescope then
        builtin.find_files({
            prompt_title = "Browse Research Notes",
            cwd = research_folder,
            hidden = false,
        })
    else
        -- Fallback to netrw
        vim.cmd("Explore " .. research_folder)
    end
end

function M.capture()
    local has_telescope, pickers = pcall(require, "telescope.pickers")
    if not has_telescope then
        -- Fallback to vim.ui.select if telescope is not installed
        local options = { "Todo", "Epiphany", "Research" }
        vim.ui.select(options, { prompt = "Capture type:" }, function(choice)
            if not choice then return end
            
            if choice == "Todo" then
                M.capture_todo()
            else
                vim.ui.input({ prompt = choice .. " Title: " }, function(input)
                    if not input or input == "" then return end
                    if choice == "Epiphany" then
                        M.create_epiphany(input)
                    elseif choice == "Research" then
                        M.create_research_note(input)
                    end
                end)
            end
        end)
        return
    end

    local finders = require "telescope.finders"
    local conf = require("telescope.config").values
    local actions = require "telescope.actions"
    local action_state = require "telescope.actions.state"
    local themes = require "telescope.themes"

    pickers.new(themes.get_dropdown({}), {
        prompt_title = "Capture Type",
        finder = finders.new_table {
            results = { "Todo", "Epiphany", "Research" }
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                local choice = selection[1]

                if choice == "Todo" then
                    M.capture_todo()
                else
                    vim.ui.input({ prompt = choice .. " Title: " }, function(input)
                        if not input or input == "" then return end

                        if choice == "Epiphany" then
                            M.create_epiphany(input)
                        elseif choice == "Research" then
                            M.create_research_note(input)
                        end
                    end)
                end
            end)
            return true
        end,
    }):find()
end

return M
