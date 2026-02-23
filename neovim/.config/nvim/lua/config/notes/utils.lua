local M = {}

-- Get current date formatted for file headers
function M.get_date()
    return os.date("%Y-%m-%d %H:%M")
end

-- Sanitize a string to be used as a filename
function M.sanitize_filename(title)
    return title:gsub("%s+", "_"):gsub("[^%w_]", ""):lower() .. ".md"
end

-- Ensure a directory exists
function M.ensure_dir(path)
    if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, "p")
    end
end

-- Append content to a file, ensuring the directory exists
function M.append_to_file(path, content)
    local expanded_path = vim.fn.expand(path)
    local dir = vim.fn.fnamemodify(expanded_path, ":h")
    
    M.ensure_dir(dir)

    local file = io.open(expanded_path, "a")
    if file then
        file:write(content .. "\n")
        file:close()
        vim.notify("Captured to " .. expanded_path)
    else
        vim.notify("Failed to open file: " .. expanded_path, vim.log.levels.ERROR)
    end
end

-- Create a floating window with the given content
function M.create_floating_window(content, title)
    -- Create a new scratch buffer
    local buf = vim.api.nvim_create_buf(false, true)
    
    -- Set buffer lines
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
    
    -- Calculate window size (80% of screen)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Window config
    local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = title or "Preview",
        title_pos = "center"
    }

    -- Create window
    local win = vim.api.nvim_open_win(buf, true, opts)

    -- Set options
    vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
    vim.api.nvim_set_option_value("filetype", "markdown", { buf = buf })
    vim.api.nvim_set_option_value("wrap", true, { win = win })

    -- Keymap to close
    vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win, true) end, { buffer = buf, nowait = true })

    return buf, win
end

-- Open a specific file in a floating window (editable)
function M.open_file_popup(path, title)
    local expanded_path = vim.fn.expand(path)
    local dir = vim.fn.fnamemodify(expanded_path, ":h")
    M.ensure_dir(dir)

    -- Ensure file exists so bufadd works correctly
    if vim.fn.filereadable(expanded_path) == 0 then
        local file = io.open(expanded_path, "w")
        if file then file:close() end
    end

    local buf = vim.fn.bufadd(expanded_path)
    vim.fn.bufload(buf)

    -- Calculate window size (80% of screen)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
        title = title or "Edit",
        title_pos = "center"
    }

    local win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_set_option_value("wrap", true, { win = win })

    -- Keymap to close
    vim.keymap.set("n", "q", function() 
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end, { buffer = buf, nowait = true, silent = true })

    return buf, win
end

return M
