-- credit to: https://github.com/rubiin/fortune.nvim
-- TODO: make this at least 60 chars
local tips = {
    "<number>G goes to the line with that number",
    "If text is wrapping use gk and gj to move up and down",
    "Use CTRL-A and CTRL-X to increment and decrement numbers",
    "Use `:%!xxd` to convert a file to hexadecimal",
    "Use `:Cfilter!` to clear the quickfix list filter",
    "Use `:Cfilter` to filter the quickfix list",
    "Use `:TOhtml` followed by a filename to save the HTML output to a file",
    "Use `:TOhtml` to convert the current buffer to HTML",
    "Use `:cdo` to execute a command on each error in the quickfix list",
    "Use `:changes` to display a list of recent changes",
    "Use `:cnext` and `:cprev` to navigate through quickfix list items",
    "Use `:colder` and `:cnewer` to navigate through older and newer quickfix lists",
    "Use `:compiler` followed by a compiler name to set the compiler",
    "Use `:cw` to open the quickfix list window",
    "Use `:delmarks a b c` to delete marks a, b, and c",
    "Use `:e!` to reload the current file from disk, discarding changes",
    "Use `:echo &option` to display the current value of an option",
    "Use `:edit` or `:e` to open a file for editing",
    "Use `:g!` followed by a pattern and a command to execute the command on lines that don't match the pattern",
    "Use `:g//m$` to move all lines matching a pattern to the end of the file",
    "Use `:g/^/m0` to reverse the order of lines in a buffer",
    "Use `:g/pattern/d` to delete lines containing a specific pattern",
    "Use `:g` followed by a pattern and a command to execute the command on lines that match the pattern",
    "Use `:global` as an alias for `:g`",
    "Use `:grep` to search for patterns in multiple files",
    "Use `:help g` to learn about the powerful uses of the g command",
    "Use `:history` to display command-line history",
    "Use `:ju` or `:jumps` to display a list of jump locations",
    "Use `:lclose` to close the location list window",
    "Use `:ldo` to execute a command on each error in the location list",
    "Use `:lfirst` to move to the first error in the location list",
    "Use `:lgrep` to perform a search using the location list",
    "Use `:llast` to move to the last error in the location list",
    "Use `:lmake` to run make and populate the location list with errors",
    "Use `:lnext` to move to the next error in the location list",
    "Use `:lopen` followed by a number to open the location list window and jump to the specified error",
    "Use `:lopen` to open the location list window",
    "Use `:lprevious` to move to the previous error in the location list",
    "Use `:ls` to list all open buffers",
    "Use `:lvimgrep` to perform a search using the location list and the quickfix list",
    "Use `:make!` to force make command execution",
    "Use `:make` followed by a program name to compile a program",
    "Use `:marks` to list all the current marks",
    "Use `:pwd` to display the current working directory",
    "Use `:r` followed by a filename to insert the contents of a file at the current cursor position",
    "Use `:read` followed by a shell command to insert the output of a command at the current cursor position",
    "Use `:registers *`  display the contents of a specific register",
    "Use `:registers` to display the contents of all registers",
    "Use `:scriptnames` to display a list of sourced scripts",
    "Use `:sort u` to remove duplicate lines in a buffer",
    "Use `:sort` to sort lines in a buffer",
    "Use `:source` followed by a file path to execute a Vimscript file",
    "Use `:sp filename` to open a file in a horizontal split",
    "Use `:sp term://$SHELL` to open a terminal in a horizontal split",
    "Use `:sview` to open a file in readonly mode",
    "Use `:tabclose` to close the current tab",
    "Use `:tabnew` to open a new tab",
    "Use `:tabnext` or `gt` to switch to the next tab",
    "Use `:tabprevious` or `gT` to switch to the previous tab",
    "Use `:term` or `:terminal` to open a terminal window",
    "Use `:verbose set option?` to find out where an option was last set",
    "Use `:vertical resize +/-n` to adjust the width of the current split",
    "Use `:vglobal` to execute a command on lines that don't match a pattern",
    "Use `:vimgrep` to perform a search using the quickfix list",
    "Use `:vsp filename` to open a file in a vertical split",
    "Use `:vsp term://$SHELL` to open a terminal in a vertical split",
    "Use `:w !sudo tee %` to save a file that requires root permission",
    "Use `Ctrl-W h/j/k/l` to navigate between splits",
    "Use `Ctrl-W` followed by `C` to exit terminal mode",
    "Use `Ctrl-W` followed by `N` to switch to normal mode in terminal mode",
    "`:%s/./&/gn` counts characters in a buffer",
    "`:%s/^//n` counts lines in a buffer",
    "use `gv` to re-select the previous visual selection",
    "Use `ZZ` in normal mode to quit nvim",
}

local function get_tips()
    math.randomseed(os.time())
    math.random()

    local tip = tips[math.random(1, #tips)]
    local lines = {}
    local current_line = ""

    for word in tip:gmatch("%S+") do
        if current_line == "" then
            current_line = word
        elseif #current_line + #word + 1 <= 60 then
            current_line = current_line .. " " .. word
        else
            table.insert(lines, current_line)
            current_line = word
        end
    end

    if current_line ~= "" then
        table.insert(lines, current_line)
    end

    return table.concat(lines, "\n")
end

return get_tips()
