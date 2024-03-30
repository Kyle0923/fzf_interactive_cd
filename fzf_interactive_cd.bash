
# supercharged cd
alias ..='c ..'
function c() {
    if [ $# -eq 0 ] ; then
        # no arguments
        local CD_PATH=`fzf_interactive_cd`
        [[ -n $CD_PATH ]] && c $CD_PATH
    elif [ $1 == '-' ] ; then
        builtin cd -
    elif [[ $1 == '..' ]] && [[ $# -gt 1 ]] ; then
        # support '.. .. ..' and '.. 3'
        shift
        if [[ $1 =~ ^[0-9]+$ ]]; then
            for counter in $(seq 1 $1); do local up_path="../$up_path"; done && c "$up_path"
        else
            c ..$(printf "/%s" "$@")
        fi
        return
    elif [ -d $1 ] ; then
        builtin cd "$1"
    elif [ -f $1 ] ; then
        echo "$1"
        builtin cd "$(dirname $1)"
    else
        echo c: "$1": No such file or directory
    fi
}


# fzf customization

# using \ as trigger, i.e., type: c \ [tab]
export FZF_COMPLETION_TRIGGER='\'

##################################################################################################################
# fzf auto-completion binding

_fzf_complete_c() {
    local TRIM_LS_SYMBOL="sed -E -e 's/[*=>@|]\$//'"
    local POP_LAST_DIR="sed -E -e 's+\/.*\/$+\/+'"
    # if is dir, enter, otherwise accept current file
    local ENTER_DIR="[[ -d \$(echo \$FZF_PROMPT{}) ]] &&
            echo \"change-prompt(\$(echo \$FZF_PROMPT{}))+reload(ls -a -F \$FZF_PROMPT{} | tail -n +3)+clear-query\" ||
            echo \"become(echo \$FZF_PROMPT{} | $TRIM_LS_SYMBOL)\""
    _fzf_complete \
    --no-multi --reverse --preview-window='right,50%,border-left' \
    --ansi --sort \
    --height="80%" \
    --color hl:underline,hl+:underline \
    --border-label-pos=2 \
    --border-label "`pwd`" \
    --prompt="`pwd | sed -E -e 's+^\/\$++'`/" \
    --header 'Alt-Enter: accept path; CTRL-W: go up; Alt-A: show all files' \
    --preview "echo \$FZF_PROMPT{} | $TRIM_LS_SYMBOL | xargs fzf_previewer" \
    \
    --bind "start:reload(ls -a -F . | tail -n +3)" \
    --bind 'change:first' \
    --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' \
    --bind "enter:transform:$ENTER_DIR" \
    --bind "tab:transform:$ENTER_DIR" \
    --bind "ctrl-d:clear-query" \
    --bind "left:transform:[[ -z {q} && \$(echo \$FZF_PROMPT{}) != '/' ]] &&
            echo \"change-prompt(\$(dirname \$FZF_PROMPT | sed -E -e 's+^\/\$++')/)+reload(ls -a -F \$(dirname \$FZF_PROMPT) | tail -n +3)+clear-query\" ||
            echo backward-char" \
    --bind "right:transform:[[ -z {q} && -d \$(echo \$FZF_PROMPT{}) ]] &&
            echo \"change-prompt(\$(echo \$FZF_PROMPT{}))+reload(ls -a -F \$FZF_PROMPT{} | tail -n +3)+clear-query\" ||
            echo forward-char" \
    --bind "ctrl-w:transform:[[ \$(echo \$FZF_PROMPT{}) != '/' ]] &&
            echo \"change-prompt(\$(dirname \$FZF_PROMPT | sed -E -e 's+^\/\$++')/)+reload(ls -a -F \$(dirname \$FZF_PROMPT) | tail -n +3)+clear-query\"" \
    --bind "alt-a:reload(cd \$FZF_PROMPT && fd -I | xargs ls -F -d | sed -E -e 's+^./++')" \
    --bind "alt-enter:transform:echo \"become(echo \$FZF_PROMPT)\"" \
    --bind "alt-left:beginning-of-line,alt-right:end-of-line" \
    --bind "alt-up:preview-up,alt-down:preview-down" \
    -- "$@" < <(echo)
}
[ -n "$BASH" ] && complete -F _fzf_complete_c -o default -o bashdefault c

##################################################################################################################
# interactively select a path and echo out on return
fzf_interactive_cd() {
    local TRIM_LS_SYMBOL="sed -E -e 's/[*=>@|]\$//'"
    local POP_LAST_DIR="sed -E -e 's+\/.*\/$+\/+'"
    # if is dir, enter, otherwise accept current file
    local ENTER_DIR="[[ -d \$(echo \$FZF_PROMPT{}) ]] &&
            echo \"change-prompt(\$(echo \$FZF_PROMPT{}))+reload(ls -a -F \$FZF_PROMPT{} | tail -n +3)+clear-query\" ||
            echo \"become(echo \$FZF_PROMPT{} | $TRIM_LS_SYMBOL)\""
    : | fzf \
    --no-multi --reverse --preview-window='right,50%,border-left' \
    --ansi --sort \
    --height="80%" \
    --color hl:underline,hl+:underline \
    --border-label-pos=2 \
    --border-label "`pwd`" \
    --prompt="`pwd | sed -E -e 's+^\/\$++'`/" \
    --header 'Alt-Enter: accept path; CTRL-W: go up; Alt-A: show all files' \
    --preview "echo \$FZF_PROMPT{} | $TRIM_LS_SYMBOL | xargs fzf_previewer" \
    \
    --bind "start:reload(ls -a -F . | tail -n +3)" \
    --bind 'change:first' \
    --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' \
    --bind "enter:transform:$ENTER_DIR" \
    --bind "tab:transform:$ENTER_DIR" \
    --bind "ctrl-d:clear-query" \
    --bind "left:transform:[[ -z {q} && \$(echo \$FZF_PROMPT{}) != '/' ]] &&
            echo \"change-prompt(\$(dirname \$FZF_PROMPT | sed -E -e 's+^\/\$++')/)+reload(ls -a -F \$(dirname \$FZF_PROMPT) | tail -n +3)+clear-query\" ||
            echo backward-char" \
    --bind "right:transform:[[ -z {q} && -d \$(echo \$FZF_PROMPT{}) ]] &&
            echo \"change-prompt(\$(echo \$FZF_PROMPT{}))+reload(ls -a -F \$FZF_PROMPT{} | tail -n +3)+clear-query\" ||
            echo forward-char" \
    --bind "ctrl-w:transform:[[ \$(echo \$FZF_PROMPT{}) != '/' ]] &&
            echo \"change-prompt(\$(dirname \$FZF_PROMPT | sed -E -e 's+^\/\$++')/)+reload(ls -a -F \$(dirname \$FZF_PROMPT) | tail -n +3)+clear-query\"" \
    --bind "alt-a:reload(cd \$FZF_PROMPT && fd -I | xargs ls -F -d | sed -E -e 's+^./++')" \
    --bind "alt-enter:transform:echo \"become(echo \$FZF_PROMPT)\"" \
    --bind "alt-left:beginning-of-line,alt-right:end-of-line" \
    --bind "alt-up:preview-up,alt-down:preview-down" \

}
