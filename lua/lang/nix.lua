local nix = {}

nix.lsp = {
    nixd = {
        settings = {
            nixd = {
                nixpkgs = { expr = "import <nixpkgs> {}" },
                options = {
                    home_manager = {
                        expr = '(builtins.getFlake "github:bossearch/nix-config").homeConfigurations."bosse@silvia".options',
                    },
                    nixos = {
                        expr = '(builtins.getFlake "github:bossearch/nix-config").nixosConfigurations.silvia.options',
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
