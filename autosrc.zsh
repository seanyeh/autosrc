AUTOSRC=".autosrc"

AUTOSRC_IGNORE=0

autosrc_clear(){
    unset -f "autosrc_enter" 2>/dev/null
    unset -f "autosrc_exit" 2>/dev/null
}

autosrc_find(){
    local curpath="$1"

    while [ "$curpath" != "/" ]; do
        local temp_file="$curpath/$AUTOSRC"
        if [ -r "$temp_file" ]; then
            autosrc_file="$temp_file"
            return 0
        fi

        curpath=$(dirname "$curpath")
    done

    return 1
}

autosrc_is_func() {
    declare -f "$1" > /dev/null; return $?
}

autosrc_call(){
    local autosrc_file="$1"
    local autosrc_func="autosrc_$2"

    # Clear temp functions/variables
    autosrc_clear

    local cur_dir="$(pwd)"
    source "$autosrc_file"


    if autosrc_is_func "$autosrc_func"; then
        AUTOSRC_IGNORE=1
        cd $(dirname "$autosrc_file")

        $autosrc_func

        cd "$cur_dir"

        AUTOSRC_IGNORE=0
    fi
}

autosrc_run() {
    if [ "$AUTOSRC_IGNORE" -eq 1 ]; then
        return
    fi

    local cur_pwd="$(pwd)"

    # If same dir, exit
    if [ "$OLDPWD" = "$cur_pwd" ]; then
        return
    fi

    autosrc_find "$OLDPWD" && local prev_autosrc="$autosrc_file"
    autosrc_find "$cur_pwd" && local cur_autosrc="$autosrc_file"

    # If same autosrc, return
    if [ "$prev_autosrc" = "$cur_autosrc" ]; then
        return
    fi

    # Call exit for previous .autosrc
    if [ -n "$prev_autosrc" ]; then
        autosrc_call "$prev_autosrc" "exit"
    fi

    # Call enter for current .autosrc
    if [ -n "$cur_autosrc" ]; then
        autosrc_call "$cur_autosrc" "enter"
    fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd autosrc_run

# Call on startup as well
autosrc_find "$(pwd)" && autosrc_call "$autosrc_file" "enter"
