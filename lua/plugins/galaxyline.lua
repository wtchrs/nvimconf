-- Galaxyline Settings
-- This settings are from
-- https://github.com/nvimdev/galaxyline.nvim/blob/main/example/spaceline.lua

local colors = {
  bg = '#282c34',
  yellow = '#fabd2f',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#afd700',
  orange = '#FF8800',
  purple = '#5d4d7a',
  magenta = '#d16d9e',
  grey = '#c0c0c0',
  blue = '#0087d7',
  red = '#ec5f67'
}

local short_line_list = {
  'neo-tree',
  'dashboard',
  'dbui',
  'startify',
  'term',
}

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
    return true
  end
  return false
end

local checkwidth = function()
  local squeeze_width  = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

local config = function()
  local gl = require('galaxyline')
  local gls = gl.section

  gl.short_line_list = short_line_list

  gls.left[1] = {
    FirstElement = {
      provider = function() return '▋' end,
      highlight = {colors.blue,colors.yellow}
    },
  }

  gls.left[2] = {
    ViMode = {
      provider = function()
        local alias = {n = ' NORMAL ',i = ' INSERT ',c= ' COMMAND ',v= ' VISUAL ',V= ' VISUAL LINE ', [''] = ' VISUAL BLOCK '}
        return alias[vim.fn.mode()]
      end,
      separator = ' ',
      separator_highlight = {colors.yellow,function()
        if not buffer_not_empty() then
          return colors.purple
        end
        return colors.darkblue
      end},
      highlight = {colors.magenta,colors.yellow,'bold'},
    },
  }

  gls.left[3] ={
    FileIcon = {
      provider = 'FileIcon',
      condition = buffer_not_empty,
      highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.darkblue},
    },
  }

  gls.left[4] = {
    FileName = {
      provider = {'FileName','FileSize'},
      condition = buffer_not_empty,
      separator = '',
      separator_highlight = {colors.purple,colors.darkblue},
      highlight = {colors.magenta,colors.darkblue}
    }
  }

  gls.left[5] = {
    GitIcon = {
      provider = function() return '  ' end,
      condition = buffer_not_empty,
      highlight = {colors.orange,colors.purple},
    }
  }

  gls.left[6] = {
    GitBranch = {
      provider = 'GitBranch',
      condition = buffer_not_empty,
      separator = ' ',
      separator_highlight = {colors.grey,colors.purple},
      highlight = {colors.grey,colors.purple},
    }
  }

  gls.left[7] = {
    DiffAdd = {
      provider = 'DiffAdd',
      condition = checkwidth,
      icon = ' ',
      highlight = {colors.green,colors.purple},
    }
  }

  gls.left[8] = {
    DiffModified = {
      provider = 'DiffModified',
      condition = checkwidth,
      icon = ' ',
      highlight = {colors.orange,colors.purple},
    }
  }

  gls.left[9] = {
    DiffRemove = {
      provider = 'DiffRemove',
      condition = checkwidth,
      icon = ' ',
      highlight = {colors.red,colors.purple},
    }
  }

  gls.left[10] = {
    LeftEnd = {
      provider = function() return '' end,
      highlight = {colors.purple,colors.bg},
      separator = ' ',
      separator_highlight = {colors.bg,colors.bg},
    }
  }

  gls.left[11] = {
    ShowLspClient = {
      provider = 'GetLspClient',
      condition = function ()
        local tbl = {['dashboard'] = true,['']=true}
        if tbl[vim.bo.filetype] then
          return false
        end
        return true
      end,
      separator = ' ',
      separator_highlight = {colors.bg,colors.bg},
      icon = '  LSP:',
      highlight = {colors.purple,colors.bg,'bold'},
    }
  }

  gls.left[12] = {
    DiagnosticError = {
      provider = 'DiagnosticError',
      icon = ' ',
      highlight = {colors.red,colors.bg},
    }
  }

  gls.left[13] = {
    DiagnosticWarn = {
      provider = 'DiagnosticWarn',
      icon = ' ',
      highlight = {colors.blue,colors.bg},
    }
  }

  gls.right[1]= {
    FileFormat = {
      provider = 'FileFormat',
      separator = ' ',
      separator_highlight = {colors.bg,colors.purple},
      highlight = {colors.grey,colors.purple},
    }
  }

  gls.right[2] = {
    LineInfo = {
      provider = 'LineColumn',
      separator = ' | ',
      separator_highlight = {colors.darkblue,colors.purple},
      highlight = {colors.grey,colors.purple},
    },
  }

  gls.right[3] = {
    PerCent = {
      provider = 'LinePercent',
      separator = '',
      separator_highlight = {colors.darkblue,colors.purple},
      highlight = {colors.grey,colors.darkblue},
    }
  }

  gls.right[4] = {
    ScrollBar = {
      --provider = 'ScrollBar',
      provider = function(scroll_bar_chars)
        local current_line = vim.fn.line('.')
        local total_lines = vim.fn.line('$')
        local default_chars = {'_', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'}
        local chars = scroll_bar_chars or default_chars
        local index = 1

        if  current_line == 1 then
          index = 1
        elseif current_line == total_lines then
          index = #chars
        else
          local line_no_fraction = vim.fn.floor(current_line) / vim.fn.floor(total_lines)
          index = vim.fn.float2nr(line_no_fraction * #chars)
          if index == 0 then
            index = 1
          end
        end
        return chars[index]
      end,
      highlight = {colors.yellow,colors.purple},
    }
  }

  gls.short_line_left[1] = {
    BufferType = {
      provider = 'FileTypeName',
      separator = '',
      separator_highlight = {colors.purple,colors.bg},
      highlight = {colors.grey,colors.purple}
    }
  }

  gls.short_line_right[1] = {
    BufferIcon = {
      provider= 'BufferIcon',
      separator = '',
      separator_highlight = {colors.purple,colors.bg},
      highlight = {colors.grey,colors.purple}
    }
  }
end

return {
  {
    "nvimdev/galaxyline.nvim",
    config = config
  }
}
