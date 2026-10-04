local cmp = require('cmp')
local config = require('cmp.config')

describe('cmp', function()
  it('registers keymaps even when cmp is disabled at InsertEnter', function()
    config.set_global({
      mapping = {
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
      },
    })

    -- The mode is normal here, so config.enabled() is false on the scheduled
    -- callback; this is the disabled-at-first-insert case.
    assert.is.truthy(vim.fn.maparg('<C-d>', 'i', false, true).desc ~= 'cmp.utils.keymap.set_map')

    vim.api.nvim_exec_autocmds('InsertEnter', {})
    vim.wait(1000, function()
      return vim.fn.maparg('<C-d>', 'i', false, true).desc == 'cmp.utils.keymap.set_map'
    end)

    assert.are.equal('cmp.utils.keymap.set_map', vim.fn.maparg('<C-d>', 'i', false, true).desc)
  end)
end)
