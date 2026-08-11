local java = {}

java.lsp = {
    jdtls = {
        settings = {
            java = {
                contentProvider = {
                    preferred = "fernflower",
                },
                compiler = {
                    annotationProcessing = {
                        enabled = true,
                    },
                },
                completion = {
                    favoriteStaticMembers = {
                        "org.junit.jupiter.api.Assertions.*",
                        "java.util.Objects.requireNonNull",
                        "java.util.Objects.requireNonNullElse",
                    },
                    importOrder = {
                        "java",
                        "javax",
                        "com",
                        "org",
                        "net.minecraft",
                    },
                },
                sources = {
                    organizeImports = {
                        starThreshold = 99,
                        staticStarThreshold = 99,
                    },
                },
                configuration = {
                    updateBuildConfiguration = "interactive",
                },
            },
        },
    },
}

java.format = {
    formatters_by_ft = {
        java = { "google-java-format" },
    },
}

java.lint = {}

return java
