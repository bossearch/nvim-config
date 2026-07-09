local qml = {}

qml.lsp = {
    qmlls = {},
}

qml.format = {
    formatters_by_ft = {
        qml = { "qmlformat" },
    },
}

qml.lint = {
    linters_by_ft = {
        qml = { "qmllint" },
    },
}

return qml
