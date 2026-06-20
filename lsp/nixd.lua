return {
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
}
