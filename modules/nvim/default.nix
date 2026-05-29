{ pkgs, ... }:
let
  vim = pkgs.writeShellScriptBin "vim" (builtins.readFile ./vim.sh);
in
{
  # LSPs and Formaters
  home.packages = [
    vim
  ]
  ++ (with pkgs; [
    # Nix
    nil
    nixfmt

    # Python
    pyright
    black

    # Lua
    stylua

    # Golang
    gopls

    # Javascript
    prettierd
  ]);

  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    package = pkgs.neovim-unwrapped;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      luasnip
      cmp_luasnip
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
      render-markdown-nvim
      nvim-web-devicons
      gitsigns-nvim
      vim-sleuth
      neovim-ayu
      lualine-nvim
      harpoon2
      mini-files
      snacks-nvim
      conform-nvim
    ];
    initLua = builtins.readFile ./init.lua;
  };
}
