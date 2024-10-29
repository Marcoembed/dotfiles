return {
	-- Colorscheme
	{ "ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000 ,
		config = function()

      		-- Load the colorscheme here
      		vim.cmd.colorscheme 'gruvbox'
		end,
	},

	{
	  'Exafunction/codeium.vim',
	  event = 'BufEnter'
	},

	{
	  "folke/which-key.nvim",
	  event = "VeryLazy",
	  opts = {
	    -- your configuration comes here
	    -- or leave it empty to use the default settings
	    -- refer to the configuration section below
	  },
	  keys = {
	    {
	      "<leader>?",
	      function()
	        require("which-key").show({ global = false })
	      end,
	      desc = "Buffer Local Keymaps (which-key)",
	    },
	  },
	},

	"folke/tokyonight.nvim",

  	-- "gc" to comment visual regions/lines
  	{
		'numToStr/Comment.nvim',
		opts = {
			padding = true,
			ignore = nil,
		},
		lazy = false
	},

  	-- Highlight todo, notes, etc in comments
  	{
		'folke/todo-comments.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = { signs = false }
	},

	{
		"nvim-lua/plenary.nvim",
		name = "plenary"
	},

	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup {
				icons = false,
			}
			vim.keymap.set('n', '<leader>tt', function()
				require('trouble').toggle()
			end)
			vim.keymap.set('n', '<leader>tn', function()
				require('trouble').next({skip_groups = true, jump = true})
			end)
			vim.keymap.set('n', '<leader>tp', function()
				require('trouble').previous({skip_groups = true, jump = true})
			end)
			vim.keymap.set('n', '<leader>dn', function() vim.diagnostic.goto_next() end)
			vim.keymap.set('n', '<leader>dp', function() vim.diagnostic.goto_prev() end)
		end
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"vimdoc", "c", "cpp", "lua"
				},
				sync_install = false,
				auto_install = false,
				indent = {
					enable = true
				},
				highlight = {
					enable = true,
				}
			})
		end
	},

	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set('n', '<leader>us', vim.cmd.UndotreeShow)
		end,

	},

	-- Git
	"tpope/vim-fugitive",

	-- Mini (Move lines)
	{
		'echasnovski/mini.nvim',
		version = '*',
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		tag = '0.1.5',
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
			 'nvim-telescope/telescope-fzf-native.nvim',
			  -- `build` is used to run some command when the plugin is installed/updated.
			  -- This is only run then, not every time Neovim starts up.
			  build = 'make',
			  -- `cond` is a condition used to determine whether this plugin should be
			  -- installed and loaded.
			  cond = function()
			    return vim.fn.executable 'make' == 1
			  end,
			},
			{ 'nvim-telescope/telescope-ui-select.nvim' },
			-- Useful for getting pretty icons, but requires special font.
			--  If you already have a Nerd Font, or terminal set up with fallback fonts
			--  you can enable this
			{ 'nvim-tree/nvim-web-devicons' },
		},

		config = function()
			-- Enable telescope extensions, if they are installed
			pcall(require('telescope').load_extension, 'fzf')
			pcall(require('telescope').load_extension, 'ui-select')
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
			vim.keymap.set('n', '<C-p>', builtin.git_files, {})
			vim.keymap.set('n', '<leader>sw', builtin.grep_string, {
				desc = '[S]earch current [W]ord' })
			vim.keymap.set('n', '<leader>s.', builtin.oldfiles, {
				desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set('n', '<leader>ps', function()
				builtin.grep_string({search = vim.fn.input("Grep > ") })
			end)
			vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
		end
	},

	{"j-hui/fidget.nvim"},

	-- LSP Config with mason
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"williamboman/mason.nvim",
			'WhoIsSethDaniel/mason-tool-installer.nvim',
			"j-hui/fidget.nvim"
		},

		config = function()
			--  This function gets run when an LSP attaches to a particular buffer.
      			--    That is to say, every time a new file is opened that is associated with
      			--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      			--    function will be executed to configure the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function (event)
					local map = function(keys, func, desc)
          					vim.keymap.set('n', keys, func,
							{ buffer = event.buf, desc = 'LSP: ' .. desc })
          				end
          				-- Jump to the definition of the word under your cursor.
          				--  To jump back, press <C-T>.
          				map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          				-- Find references for the word under your cursor.
          				map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          				-- Jump to the implementation of the word under your cursor.
          				--  Useful when declaring types without an actual implementation.
          				map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          				-- Jump to the type of the word under your cursor.
          				--  Useful when you're not sure what type a variable is and you want to
          				--  see the definition of its *type*, not where it was *defined*.
          				map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          				-- Fuzzy find all the symbols in your current document.
          				--  Symbols are things like variables, functions, types, etc.
          				map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          				-- Fuzzy find all the symbols in your current workspace
          				--  Similar to document symbols,
					--  except searches over your whole project.
          				map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          				-- Rename the variable under your cursor
          				--  Most Language Servers support renaming across files, etc.
          				map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          				-- Execute a code action, usually your cursor needs to be on top of an error
          				-- or a suggestion from your LSP for this to activate.
          				map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          				-- Opens a popup that displays documentation about the word under your cursor
          				-- WARN: This is not Goto Definition, this is Goto Declaration.
          				--  For example, in C this would take you to the header
          				map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
				end,
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
      			--  By default, Neovim doesn't support everything that is in the LSP Specification.
      			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      		local capabilities = vim.lsp.protocol.make_client_capabilities()
      		capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

			local servers = {
				bashls = {},
				clangd = {},
				cmake = {},
				hdl_checker = {},
				pylsp = {},
				verible = {
					cmd = {"verible-verilog-ls", "--rules_config_search"},
					handlers = {
						["textDocument/publishDiagnostics"] = function() end
					}
				},
				ts_ls = {},
				html = {
					filetypes={"html", "css"}
				},
				cssls = {
					filetypes={"html", "css"}
				},
			}

			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			require('mason-tool-installer').setup { ensure_installed = ensure_installed }

			require("fidget").setup({})
			require("mason-lspconfig").setup({
				handlers = {
					function (server_name)
						local server = servers[server_name] or {}
						require("lspconfig")[server_name].setup {
							cmd = server.cmd,
							settings = server.settings,
							filetypes = server.filetypes,
							capabilities = vim.tbl_deep_extend('force',
							{},
							capabilities,
							server.capabilities or {}),
							handlers = server.handlers or {},
						}
					end,
					["lua_ls"] = function ()
						local lspconfig = require("lspconfig")
						lspconfig.lua_ls.setup({
							runtime = {version = 'LuaJIT'},
							settings = {Lua = {diagnostics = {globals = {'vim'}}}},
						})
					end
				}
			})
		end,
	},


	-- Nvim-cmp [AutoComplete]

	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- LuaSnip
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",

				build = "make install_jsregexp",
				dependencies = {
					"rafamadriz/friendly-snippets",
					-- "benfowler/telescope-luasnip.nvim"
				},

				config = function ()
					local ls = require("luasnip")
					ls.filetype_extend("python", {"pydoc"})
					ls.filetype_extend("c", {"cdoc"})
					ls.filetype_extend("cpp", {"cppdoc"})
					ls.filetype_extend("sh", {"shelldoc"})

					vim.keymap.set({"i", "s"}, "<C-k>", function() ls.jump(1) end, {silent = true})
					vim.keymap.set({"i", "s"}, "<C-j>", function() ls.jump(-1) end, {silent = true})

				end,
			},
			{
			    "zbirenbaum/copilot-cmp",
			    after = { "copilot.lua" },
			    dependencies = { "zbirenbaum/copilot.lua" },
			    config = function()
			      require("copilot").setup({
			        suggestion = {
			          enabled = true,
			          auto_trigger = true,
			          debounce = 75,
			          keymap = {
			            accept = "<c-a>",
			            accept_word = false,
			            accept_line = false,
			            next = "<M-]>",
			            prev = "<M-[>",
			            dismiss = "<C-]>",
			          },
			        },
			        panel = { enabled = false },
			      })
			      -- require("copilot_cmp").setup()
			    end
			  },

			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
		},
		config = function ()
			local cmp = require("cmp")
			local ls = require("luasnip")
			local cmp_select = {behavior = cmp.SelectBehavior.Select}
			local cmp_replace = {behavior = cmp.ConfirmBehavior.Replace, select = true}

			ls.config.setup({})
			cmp.setup({
				snippet = {
					expand = function(args)
						ls.lsp_expand(args.body)
					end,
				},
				-- completion = { completeopt = 'menu,menuone,noinsert' },
				mapping = cmp.mapping.preset.insert({
					['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
					['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
					['<C-e>'] = cmp.mapping.close(),
					['<Enter>'] = cmp.mapping.confirm(cmp_replace),
					-- Manually trigger (open) a completion menu from nvim-cmp.
					-- Not really useful.
					['<C-Space>'] = cmp.mapping.complete(),
				}),

				sources = cmp.config.sources({
					{name = 'nvim_lsp'},
					{name = 'luasnip'},
				}, {
					{name = 'buffer'},
				})
			})
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snips" } })
			vim.diagnostic.config({
				virtual_text = true
			})
		end,
	},

	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function ()
			local lualine = require('lualine')
			lualine.setup({})
		end
	},

	{
	  "nvim-neo-tree/neo-tree.nvim",
	  branch = "v3.x",
	  dependencies = {
	    "nvim-lua/plenary.nvim",
	    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
	    "MunifTanjim/nui.nvim",
	    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	  },
	  opts = {
	    sources = { "filesystem", "buffers", "git_status" },
	    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
	    filesystem = {
	      bind_to_cwd = false,
	      follow_current_file = { enabled = true },
	      use_libuv_file_watcher = true,
	      components = {
        	-- Display file size
        	size = {
        	  provider = "size", -- The size component provider
        	  highlight = "NeoTreeFileSize", -- Customize the highlight group if needed
        	  -- Optionally format the size display
        	  format = function(size)
        	    return string.format("%s", size) -- Customize the format string as needed
        	  end,
        	},
      	       },
	    },
	    window = {
	      mappings = {
	        ["l"] = "open",
	        ["h"] = "close_node",
	        ["<space>"] = "none",
	        ["Y"] = {
	          function(state)
	            local node = state.tree:get_node()
	            local path = node:get_id()
	            vim.fn.setreg("+", path, "c")
	          end,
	          desc = "Copy Path to Clipboard",
	        },
	        ["O"] = {
	          function(state)
	            require("lazy.util").open(state.tree:get_node().path, { system = true })
	          end,
	          desc = "Open with System Application",
	        },
	        ["P"] = { "toggle_preview", config = { use_float = false } },
	      },
	    },
	    default_component_configs = {
	      indent = {
	        with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
	        expander_collapsed = "",
	        expander_expanded = "",
	        expander_highlight = "NeoTreeExpander",
	      },
	      git_status = {
	        symbols = {
	          unstaged = "󰄱",
	          staged = "󰱒",
	        },
	      },
      	      name = {
      	        -- Customize the display of file names and sizes here
      	        use_git_status_colors = true,
      	        highlight_opened_files = "icon",
      	        folder_empty = "", -- Customize this as needed
      	        folder_empty_open = "", -- Customize this as needed
      	        folder = "",
      	        folder_open = "",
      	        default = "*",
      	        -- Display file sizes by adding a custom component
      	        display_size = true,
      	      },
	    },
	  },
	  config = function(_, opts)
	    require("neo-tree").setup(opts)
	    vim.api.nvim_create_autocmd("TermClose", {
	      pattern = "*lazygit",
	      callback = function()
	        if package.loaded["neo-tree.sources.git_status"] then
	          require("neo-tree.sources.git_status").refresh()
	        end
	      end,
	    })
	  end,
	}
}
