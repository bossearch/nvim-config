local nix = {}

local generated = dofile(vim.fn.stdpath("cache") .. "/generated.lua")
local nixos = generated.nixd.nixos
local home_manager = generated.nixd.home_manager

nix.lsp = {
    nixd = {
        settings = {
            nixd = {
                nixpkgs = { expr = "import <nixpkgs> {}" },
                options = {
                    nixos = {
                        expr = nixos,
                    },

                    home_manager = {
                        expr = home_manager,
                    },
                },
            },
        },
    },
}

nix.format = {
    formatters_by_ft = {
        nix = { "alejandra" },
    },
}

nix.lint = {}

return nix
