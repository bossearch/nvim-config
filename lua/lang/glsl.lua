-- TODO: fix lazy load for nvim-lint
local parser = require("lint.parser")

local glsl = {}

glsl.lsp = {
    glsl_analyzer = {},
}

glsl.format = {}

glsl.lint = {
    linters = {
        glslang_validator = {
            cmd = "glslangValidator",
            stdin = true,
            append_fname = false,
            args = {
                "--stdin",
                "-l",
                "-I.",
                "-P#extension GL_GOOGLE_include_directive : enable\n",
                function()
                    local ext = vim.fn.expand("%:e")
                    local stage_map = { fsh = "frag", vsh = "vert" }
                    return stage_map[ext] and "-S" or nil
                end,
                function()
                    local ext = vim.fn.expand("%:e")
                    local stage_map = { fsh = "frag", vsh = "vert" }
                    return stage_map[ext] or nil
                end,
            },
            stream = "stdout",
            ignore_exitcode = true,
            parser = parser.from_pattern("(%u+): [^:]+:(%-?%d+): (.*)", { "severity", "lnum", "message" }, {
                ["ERROR"] = vim.diagnostic.severity.ERROR,
                ["WARNING"] = vim.diagnostic.severity.WARN,
            }, { source = "glslangValidator" }),
        },
    },
    linters_by_ft = {
        glsl = { "glslang_validator" },
    },
}

return glsl
