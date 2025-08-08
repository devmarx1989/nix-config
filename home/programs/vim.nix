# /nix/nvim.nix
{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Install Language Servers and other tools directly with Nix.
    extraPackages = with pkgs; [
      rust-analyzer # Add any other language servers here
    ];

    # Basic editor settings
    opts = {
      relativenumber = true;
      cursorline = true;
      wrap = false;
      backup = false;
      writebackup = false;
      swapfile = false;
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      hlsearch = true;
      colorcolumn = "80";
    };

    # Global variables for plugins
    globals = {
      hy_enable_conceal = 1;
      hy_conceal_fancy = 1;
      v_autofmt_bufwritepre = 1;
    };

    # Keymaps
    keymaps = [
      {
        key = ";";
        action = ":";
      }
      {
        mode = "i"; # Insert mode
        key = "<C-k>";
        action = "<esc>";
        options = {
          silent = true;
        };
      }
      {
        mode = "v"; # Visual mode
        key = "<C-k>";
        action = "<esc>";
        options = {
          silent = true;
        };
      }
    ];

    # Raw vimscript
    extraConfigVim = ''
      " Brace yourself for some magic "
      inoremap {      {}<Left>
      inoremap {<CR>  {<CR>}<Esc>O
      inoremap {{     {
      inoremap {}     {}
    '';

    # Plugins with special nixvim modules
    plugins = {
      lsp.enable = true;
      dap.enable = true;
    };

    # All other plugins without special modules
    extraPlugins = with pkgs.vimPlugins; [
      # Treesitter is treated as a regular plugin
      (nvim-treesitter.withAllGrammars)

      # The rest of your plugins from your original file
      nerdtree
      asyncomplete-lsp-vim
      asyncomplete-vim
      elm-vim
      idris-vim
      idris2-nvim
      nix-develop-nvim
      orgmode
      plenary-nvim
      rust-tools-nvim
      rust-vim
      vim-fish
      vim-graphql
      vim-llvm
      vim-nix
      vim-racket
      vim-toml
      zig-vim
    ];

    # Configure Treesitter using its standard Lua API
    extraConfigLua = ''
      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
        },
      }
    '';
  };
}
