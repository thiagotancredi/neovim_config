-----------------------------------------------------------
-- Config básica
-----------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.number = true
opt.relativenumber = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.termguicolors = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.updatetime = 300
opt.wrap = false
opt.clipboard = "unnamedplus"

-- EFEITO VIDRO (Apenas em menus/popups)
opt.winblend = 10       -- Transparência em janelas flutuantes
opt.pumblend = 10       -- Transparência em menus de autocomplete

-- Atalhos gerais
vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true, desc = "Salvar" })
vim.keymap.set("n", "<leader>q", ":bd<CR>", { silent = true, desc = "Fechar buffer atual" })
vim.keymap.set("n", "<leader>xx", vim.diagnostic.open_float, { desc = "Mostrar erro" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Erro anterior" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Próximo erro" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Ir para definição" })
vim.keymap.set("n", "<leader>.", vim.lsp.buf.code_action, { desc = "Code Action" })

-----------------------------------------------------------
-- Bootstrap do lazy.nvim
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------
require("lazy").setup({

  -------------------------------------------------------
  -- ÍCONES
  -------------------------------------------------------
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },

  -------------------------------------------------------
  -- TEMA (NORD)
  -------------------------------------------------------
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Configurações do Nord
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true
      vim.g.nord_uniform_diff_background = true

      -- Carrega o tema
      require("nord").set()
    end,
  },

  -------------------------------------------------------
  -- UI
  -------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "nord",
          globalstatus = true,
          component_separators = '|',
          section_separators = '',
        }
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        git = { enable = true },
        view = { width = 30 },

        -- NÃO compactar pasta_pai/pasta_filho e mostrar indentação
        renderer = {
          group_empty = false,
          indent_markers = { enable = true },
        },

        filters = {
          dotfiles = false,
          git_ignored = false,
          custom = {
            "^.git$",
            "^.svn$",
            "^.hg$",
            "^.DS_Store$",
            "^Thumbs.db$",
            "^__pycache__$",
            "^.ruff_cache$",
            "%.pyc$",
          },
        },
      })

      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
              padding = 1,
            }
          }
        },
      })
      vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>")
      vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>")
    end,
  },

  -------------------------------------------------------
  -- TELESCOPE
  -------------------------------------------------------
{
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        file_ignore_patterns = {
          "__pycache__",
          "%.pyc",
          ".git/",
          "node_modules/",
        },
        winblend = 10,
      },
      pickers = {
        buffers = {
          mappings = {
            i = { ["<C-d>"] = actions.delete_buffer },
            n = { ["d"] = actions.delete_buffer },
          },
        },
      },
    })

    vim.keymap.set("n", "<leader>ff", builtin.find_files)
    vim.keymap.set("n", "<leader>fg", builtin.live_grep)
    vim.keymap.set("n", "<leader>fb", builtin.buffers)
  end,
},

  -------------------------------------------------------
  -- TREESITTER
  -------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "vim", "bash", "json", "yaml" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -------------------------------------------------------
  -- GITSIGNS
  -------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -------------------------------------------------------
  -- LSP (Pyright)
  -------------------------------------------------------
  {
    "williamboman/mason.nvim",
    config = function() require("mason").setup() end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      local lspconfig = require("lspconfig")
      local mason_lspconfig = require("mason-lspconfig")

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok then capabilities = cmp_lsp.default_capabilities(capabilities) end

      local on_attach = function(_, bufnr)
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("gd", vim.lsp.buf.definition, "Ir para definição")
        map("K", vim.lsp.buf.hover, "Hover")
        map("gr", vim.lsp.buf.references, "Referências")
        map("<leader>rn", vim.lsp.buf.rename, "Renomear")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
        -- Sem <leader>f aqui (formatação ficará só no terminal)
      end

      mason_lspconfig.setup({
        ensure_installed = { "lua_ls", "pyright" },
        handlers = {
          function(server)
            lspconfig[server].setup({
              capabilities = capabilities,
              on_attach = on_attach,
            })
          end,

          ["pyright"] = function()
            lspconfig.pyright.setup({
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    typeCheckingMode = "basic",
                    diagnosticSeverityOverrides = {
                      reportPrivateImportUsage = "none",
                    },
                  },
                },
              },
            })
          end,
        },
      })
    end,
  },

  -------------------------------------------------------
  -- GITHUB COPILOT
  -------------------------------------------------------
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = "<C-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>"
          },
        },
      })
    end,
  },

  -------------------------------------------------------
  -- COPILOT CHAT
  -------------------------------------------------------
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {
      debug = false,
      window = {
        layout = 'float',
        width = 0.5,
        height = 0.5,
      },
      mappings = {
        complete = { detail = 'Usar sugestão', insert = '<C-l>' },
        close = { normal = 'q', insert = '<C-c>' },
        reset = { normal = '<C-r>', insert = '<C-r>' },
        submit_prompt = { normal = '<CR>', insert = '<CR>' },
        accept_diff = { normal = '<C-y>', insert = '<C-y>' },
        yank_diff = { normal = 'gy' },
        show_diff = { normal = 'gd' },
      },
    },
    keys = {
      { "<leader>cc", ":CopilotChatToggle<CR>", desc = "Copilot Chat (Toggle)" },
      { "<leader>ce", ":CopilotChatExplain<CR>", mode = "v", desc = "Copilot: Explicar" },
      { "<leader>cf", ":CopilotChatFix<CR>", mode = "v", desc = "Copilot: Corrigir" },
      { "<leader>ct", ":CopilotChatTests<CR>", mode = "v", desc = "Copilot: Gerar Testes" },
    },
  },

  -------------------------------------------------------
  -- AUTOCOMPLETE
  -------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

})

-----------------------------------------------------------
-- Terminal Inteligente
-----------------------------------------------------------
local function get_terminal_windows()
  local term_wins = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      table.insert(term_wins, win)
    end
  end
  return term_wins
end

local function open_smart_terminal()
  local term_wins = get_terminal_windows()
  if #term_wins == 0 then
    vim.cmd("botright split")
    vim.cmd("resize 12")
    vim.cmd("terminal")
  else
    vim.api.nvim_set_current_win(term_wins[1])
    vim.cmd("startinsert")
  end
end

local function close_smart_terminal()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype == "terminal" then
    vim.cmd("bd!")
  else
    print("Use <leader>q para fechar buffers normais.")
  end 
end

vim.keymap.set("n", "<C-j>", open_smart_terminal)
vim.keymap.set("n", "<C-q>", close_smart_terminal)
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>:bd!<CR>]], { silent = true })