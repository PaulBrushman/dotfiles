return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = true,
      highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
      },
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "zig"
      },
    },
    config = function(_,opts)
        require('nvim-treesitter.configs').setup(opts)
    end
  }
}
