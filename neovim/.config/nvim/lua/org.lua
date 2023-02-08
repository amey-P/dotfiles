-- init.lua

-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop,
  -- highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    -- Required for spellcheck, some LaTex highlights and
    -- code block highlights that do not have ts grammar
    additional_vim_regex_highlighting = {'org'},
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
  org_agenda_files = '~/org/gtd.org',
  org_capture_templates = {
      t = {
          description = "Todo",
          template = "** TODO : %?\n  %a",
          target = "~/org/gtd.org",
      },
      -- j = {
      --     description = "Journal Entry",
      --     template = "* %?\nEntered on %U\n  %i\n  %a",
      --     target = "~/org/journal.org",
      -- },
  },
  win_split_mode = 'tabnew',
})


