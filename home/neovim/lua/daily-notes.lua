local M = {}

function M.open_daily_note()
  local date = os.date("%Y-%m-%d")
  local daily_path = vim.fn.expand("~/wiki/notes/daily/" .. date .. ".md")
  local index_path = vim.fn.expand("~/wiki/notes/daily/index.md")
  
  vim.fn.mkdir(vim.fn.expand("~/wiki/notes/daily"), "p")
  
  local file_exists = vim.fn.filereadable(daily_path) == 1
  
  if not file_exists then
    -- Add to index
    local index_exists = vim.fn.filereadable(index_path) == 1
    local lines = {}
    
    if index_exists then
      lines = vim.fn.readfile(index_path)
    else
      lines = {"# Daily Notes", ""}
    end
    
    local insert_pos = 2
    for i, line in ipairs(lines) do
      if line:match("^- %[%[") then
        insert_pos = i
        break
      end
    end
    
    table.insert(lines, insert_pos, "- [[" .. date .. "]]")
    vim.fn.writefile(lines, index_path)
  end
  
  vim.cmd("edit " .. daily_path)
  
  if not file_exists then
    -- Get incomplete tasks from yesterday
    local yesterday = os.date("%Y-%m-%d", os.time() - 86400)
    local yesterday_path = vim.fn.expand("~/wiki/notes/daily/" .. yesterday .. ".md")
    local migrated_tasks = {}
    
    if vim.fn.filereadable(yesterday_path) == 1 then
      local yesterday_lines = vim.fn.readfile(yesterday_path)
      for _, line in ipairs(yesterday_lines) do
        if line:match("^%s*%- %[ %]") then
          table.insert(migrated_tasks, line)
        end
      end
    end
    
    -- Build template with migrated tasks
    local template_content = {
      "# " .. date,
      "",
      "**Date:** " .. os.date("%A, %B %d, %Y"),
      "",
      "## Tasks",
    }
    
    -- Add migrated tasks or empty task
    if #migrated_tasks > 0 then
      for _, task in ipairs(migrated_tasks) do
        table.insert(template_content, task)
      end
      table.insert(template_content, "")
    else
      table.insert(template_content, "- [ ] ")
      table.insert(template_content, "")
    end
    
    -- Add rest of template
    table.insert(template_content, "## Notes")
    table.insert(template_content, "")
    table.insert(template_content, "")
    table.insert(template_content, "## Log")
    table.insert(template_content, "")
    table.insert(template_content, "")
    
    vim.api.nvim_buf_set_lines(0, 0, -1, false, template_content)
  end
end

function M.setup()
  -- Wiki navigation keymaps
  vim.keymap.set('n', '<leader>nd', M.open_daily_note, { desc = 'Today daily note' })
  vim.keymap.set('n', '<leader>nD', '<cmd>e ~/wiki/notes/daily/index.md<CR>', { desc = 'Daily notes index' })
  vim.keymap.set('n', '<leader>nw', '<cmd>e ~/wiki/notes/weekly/index.md<CR>', { desc = 'Weekly notes' })
  vim.keymap.set('n', '<leader>nm', '<cmd>e ~/wiki/notes/monthly/index.md<CR>', { desc = 'Monthly notes' })
  vim.keymap.set('n', '<leader>ny', '<cmd>e ~/wiki/notes/yearly/index.md<CR>', { desc = 'Yearly notes' })
  vim.keymap.set('n', '<leader>ni', '<cmd>e ~/wiki/index.md<CR>', { desc = 'Wiki index' })
end

return M
