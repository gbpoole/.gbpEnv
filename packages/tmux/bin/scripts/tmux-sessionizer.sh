#!/usr/bin/env bash

# This script is taken from the Primagen, found here:
# https://github.com/ThePrimeagen/tmux-sessionizer/blob/7edf8211e36368c29ffc0d2c6d5d2d350b4d729b/tmux-sessionizer

CONFIG_FILE_NAME="tmux-sessionizer.conf"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux-sessionizer"
CONFIG_FILE="$CONFIG_DIR/$CONFIG_FILE_NAME"
PANE_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/tmux-sessionizer"
PANE_CACHE_FILE="$PANE_CACHE_DIR/panes.cache"

# config file example
# ------------------------
# # file: ~/.config/tmux-sessionizer/tmux-sessionizer.conf
# # If set this override the default TS_SEARCH_PATHS (~/ ~/personal ~/personal/dev/env/.config)
# TS_SEARCH_PATHS=(~/)
# # If set this add additional search paths to the default TS_SEARCH_PATHS
# # The number prefix is the depth for the Path [OPTIONAL]
# TS_EXTRA_SEARCH_PATHS=(~/ghq:3 ~/Git:3 ~/.config:2)
# # if set this override the TS_MAX_DEPTH (1)
# TS_MAX_DEPTH=2
# This is not meant to override .tmux-sessionizer.  At first i thought this
# would be a good command, but i don't think its ackshually what i want.
#
# Instead, its a list of commands to run on windows who's index is way outside
# of the first 10 windows.  This allows you to create as many windows in your
# session as you would like without having your workflow interrupted by these
# programatic windows
#
# how to use:
# tmux-sessionizer -w 0 will execute the first command in window -t 69.
# TS_SESSION_COMMANDS=(<cmd1> <cmd2>)
#
# TS_LOG=true # will write logs to ~/.local/share/tmux-sessionizer/tmux-sessionizer.logs
# TS_LOG_FILE=<file> # will write logs to <file> Defaults to ~/.local/share/tmux-sessionizer/tmux-sessionizer.logs
# ------------------------

if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
fi

if [[ -f "$CONFIG_FILE_NAME" ]]; then
    source "$CONFIG_FILE_NAME"
fi

if [[ $TS_LOG != "true" ]]; then
    if [[ -z $TS_LOG_FILE ]]; then
        TS_LOG_FILE="$HOME/.local/share/tmux-sessionizer/tmux-sessionizer.logs"
    fi

    mkdir -p "$(dirname "$TS_LOG_FILE")"
fi

log() {
    if [[ -z $TS_LOG ]]; then
        return
    fi

    local timestamp
    timestamp=$(date "+%Y-%m-%d %H:%M:%S")

    if [[ $TS_LOG == "echo" ]]; then
        echo "[$timestamp] $*"
    elif [[ $TS_LOG == "file" ]]; then
        echo "[$timestamp] $*" >> "$TS_LOG_FILE"
    fi
}

session_idx=""
session_cmd=""
user_selected=""
split_type=""
VERSION="0.1.0"

while [[ "$#" -gt 0 ]]; do
    case "$1" in
    -h | --help)
        echo "Usage: tmux-sessionizer [OPTIONS] [SEARCH_PATH]"
        echo "Options:"
        echo "  -h, --help             Display this help message"
        echo "  -s, --session <name>   session command index."
        echo "  --vsplit               Create vertical split (horizontal layout) for session command"
        echo "  --hsplit               Create horizontal split (vertical layout) for session command"
        exit 0
        ;;
    -s | --session)
        session_idx="$2"
        if [[ -z $session_idx ]]; then
            echo "Session index cannot be empty"
            exit 1
        fi

        if [[ -z $TS_SESSION_COMMANDS ]]; then
            echo "TS_SESSION_COMMANDS is not set.  Must have a command set to run when switching to a session"
            exit 1
        fi

        if [[ -z "$session_idx" || "$session_idx" -lt 0 || "$session_idx" -ge "${#TS_SESSION_COMMANDS[@]}" ]]; then
            echo "Error: Invalid index. Please provide an index between 0 and $((${#TS_SESSION_COMMANDS[@]} - 1))."
            exit 1
        fi

        session_cmd="${TS_SESSION_COMMANDS[$session_idx]}"

        shift
        ;;
    --vsplit)
        split_type="vsplit"
        ;;
    --hsplit)
        split_type="hsplit"
        ;;
    -v | --version)
        echo "tmux-sessionizer version $VERSION"
        exit 0
        ;;
    *)
        user_selected="$1"
        ;;
    esac
    shift
done

log "tmux-sessionizer($VERSION): idx=$session_idx cmd=$session_cmd user_selected=$user_selected split_type=$split_type log=$TS_LOG log_file=$TS_LOG_FILE"

# Validate split options are only used with session commands
if [[ -n "$split_type" && -z "$session_idx" ]]; then
    echo "Error: --vsplit and --hsplit can only be used with -s/--session option"
    exit 1
fi

sanity_check() {
    if ! command -v tmux &>/dev/null; then
        echo "tmux is not installed. Please install it first."
        exit 1
    fi

    if ! command -v fzf &>/dev/null; then
        echo "fzf is not installed. Please install it first."
        exit 1
    fi
}

ensure_valid_term() {
    if [[ -z "$TERM" ]]; then
        log "TERM is unset"
        echo "tmux-sessionizer: TERM is unset" >> /tmp/tmux-sessionizer/tmux-sessionizer.err
        tmux display-message "tmux-sessionizer: TERM is unset"
        exit 1
    fi

    if ! infocmp "$TERM" >/dev/null 2>&1; then
        log "TERM $TERM is missing"
        echo "tmux-sessionizer: missing terminfo for $TERM" >> /tmp/tmux-sessionizer/tmux-sessionizer.err
        tmux display-message "tmux-sessionizer: missing terminfo for $TERM"
        exit 1
    fi
}

switch_to() {
    if [[ -z $TMUX ]]; then
        log "attaching to session $1"
        tmux attach-session -t "$1"
    else
        log "switching to session $1"
        tmux switch-client -t "$1"
    fi
}

has_session() {
    tmux has-session -t "$1" 2>/dev/null
}

sanitize_session_name() {
    local raw="$1"
    local sanitized

    sanitized=$(printf '%s' "$raw" | sed -E 's/[^[:alnum:]_-]+/_/g; s/^_+//; s/_+$//')

    if [[ -z "$sanitized" ]]; then
        sanitized="session"
    fi

    printf '%s' "$sanitized"
}

session_name_from_path() {
    local path="$1"
    local trimmed_path="${path%/}"
    local base_name

    if [[ -z "$trimmed_path" ]]; then
        base_name="$path"
    else
        base_name="$(basename "$trimmed_path")"
    fi

    sanitize_session_name "$base_name"
}

unique_session_name() {
    local base_name="$1"
    local candidate="$base_name"
    local idx=1

    while has_session "$candidate"; do
        candidate="${base_name}_${idx}"
        idx=$((idx + 1))
    done

    printf '%s' "$candidate"
}

build_display_path() {
    local path="$1"
    local best_idx=-1
    local best_len=-1

    for i in "${!TS_SEARCH_BASES_EXPANDED[@]}"; do
        local base="${TS_SEARCH_BASES_EXPANDED[$i]}"
        local base_len=${#base}

        if [[ "$path" == "$base" || "$path" == "$base"/* ]]; then
            if (( base_len > best_len )); then
                best_len=$base_len
                best_idx=$i
            fi
        fi
    done

    if (( best_idx == -1 )); then
        printf '%s' "$path"
        return
    fi

    local name_override="${TS_SEARCH_BASES_NAME_OVERRIDE[$best_idx]}"
    if [[ -n "$name_override" ]]; then
        printf '%s' "$name_override"
        return
    fi

    local prefix="${TS_SEARCH_BASES_DISPLAY[$best_idx]}"
    local base="${TS_SEARCH_BASES_EXPANDED[$best_idx]}"
    local relative="${path#"$base"}"

    if [[ -z "$relative" || "$relative" == "$path" ]]; then
        printf '%s' "$prefix"
        return
    fi

    relative="${relative#/}"
    if [[ -z "$relative" ]]; then
        printf '%s' "$prefix"
        return
    fi

    printf '%s/%s' "$prefix" "$relative"
}

expand_search_base() {
    local raw_base="$1"

    SEARCH_BASE_EXPANDED="$raw_base"
    SEARCH_BASE_DISPLAY=""

    if [[ "$raw_base" == "~" ]]; then
        SEARCH_BASE_DISPLAY="~"
        SEARCH_BASE_EXPANDED="$HOME"
    elif [[ "$raw_base" == "~/"* ]]; then
        SEARCH_BASE_EXPANDED="$HOME/${raw_base#\~\/}"
        SEARCH_BASE_EXPANDED="${SEARCH_BASE_EXPANDED%/}"
        SEARCH_BASE_DISPLAY="$(basename "$SEARCH_BASE_EXPANDED")"
    else
        SEARCH_BASE_EXPANDED="${SEARCH_BASE_EXPANDED%/}"
        SEARCH_BASE_DISPLAY="$(basename "$SEARCH_BASE_EXPANDED")"
    fi
}

relative_depth() {
    local base="$1"
    local path="$2"
    local rel="${path#"$base"}"

    rel="${rel#/}"
    if [[ -z "$rel" ]]; then
        printf '0'
        return
    fi

    local -a parts
    IFS='/' read -r -a parts <<< "$rel"
    printf '%s' "${#parts[@]}"
}

should_exclude_path() {
    local path="$1"
    local normalized_path="$path"

    if [[ "$normalized_path" != "/" ]]; then
        normalized_path="${normalized_path%/.}"
        normalized_path="${normalized_path%/}"
    fi

    for i in "${!TS_EXCLUDE_BASES_EXPANDED[@]}"; do
        local base="${TS_EXCLUDE_BASES_EXPANDED[$i]}"
        local depth="${TS_EXCLUDE_DEPTHS[$i]}"

        if [[ "$normalized_path" != "$base" && "$normalized_path" != "$base"/* ]]; then
            continue
        fi

        if [[ "$depth" -eq 0 ]]; then
            if [[ "$normalized_path" == "$base" ]]; then
                return 0
            fi
            continue
        fi

        if [[ "$depth" -gt 0 ]]; then
            [[ -d "$normalized_path/.git" ]] || continue
            local rel_depth
            rel_depth=$(relative_depth "$base" "$normalized_path")
            if (( rel_depth <= depth )); then
                return 0
            fi
            continue
        fi

        local abs_depth=$(( -depth ))
        local rel_depth
        rel_depth=$(relative_depth "$base" "$normalized_path")
        if (( rel_depth <= abs_depth )); then
            return 0
        fi
    done

    return 1
}

ensure_session() {
    local name="$1"
    local path="$2"

    if ! is_tmux_running; then
        log "creating session $name (tmux not running)"
        tmux new-session -ds "$name" -c "$path" 2>/tmp/tmux-sessionizer/tmux-sessionizer.err
        local status=$?
        if [[ $status -ne 0 ]]; then
            local err_msg
            err_msg=$(cat /tmp/tmux-sessionizer/tmux-sessionizer.err 2>/dev/null)
            log "failed to create session $name status=$status err=$err_msg"
            tmux display-message "tmux-sessionizer: failed to create session '$name'"
            return 1
        fi
        hydrate "$name" "$path"
        return 0
    fi

    if has_session "$name"; then
        return 0
    fi

    log "creating session $name in $path"
    tmux new-session -ds "$name" -c "$path" 2>/tmp/tmux-sessionizer/tmux-sessionizer.err
    local status=$?
    if [[ $status -ne 0 ]]; then
        local err_msg
        err_msg=$(cat /tmp/tmux-sessionizer/tmux-sessionizer.err 2>/dev/null)
        log "failed to create session $name status=$status err=$err_msg"
        tmux display-message "tmux-sessionizer: failed to create session '$name'"
        return 1
    fi

    if ! has_session "$name"; then
        log "session $name not found after creation"
        tmux display-message "tmux-sessionizer: session '$name' was not created"
        return 1
    fi

    hydrate "$name" "$path"
    return 0
}

hydrate() {
    if [[ ! -z $session_cmd ]]; then
        log "skipping hydrate for $1 -- using \"$session_cmd\" instead"
        return
    elif [ -f "$2/.tmux-sessionizer.sh" ]; then
        log "sourcing(local) $2/.tmux-sessionizer.sh"
        tmux send-keys -t "$1" "source \"$2/.tmux-sessionizer.sh\"" c-M
    elif [ -f "$HOME/.tmux-sessionizer.sh" ]; then
        log "sourcing(global) $HOME/.tmux-sessionizer.sh"
        tmux send-keys -t "$1" "source \"$HOME/.tmux-sessionizer.sh\"" c-M
    fi
}

is_tmux_running() {
    tmux_running=$(pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        return 1
    fi
    return 0
}

init_pane_cache() {
    mkdir -p "$PANE_CACHE_DIR"
    touch "$PANE_CACHE_FILE"
}

get_pane_id() {
    local session_idx="$1"
    local split_type="$2"
    init_pane_cache
    grep "^${session_idx}:${split_type}:" "$PANE_CACHE_FILE" | cut -d: -f3
}

set_pane_id() {
    local session_idx="$1"
    local split_type="$2"
    local pane_id="$3"
    init_pane_cache

    # Remove existing entry if it exists
    grep -v "^${session_idx}:${split_type}:" "$PANE_CACHE_FILE" > "${PANE_CACHE_FILE}.tmp" 2>/dev/null || true
    mv "${PANE_CACHE_FILE}.tmp" "$PANE_CACHE_FILE"

    # Add new entry
    echo "${session_idx}:${split_type}:${pane_id}" >> "$PANE_CACHE_FILE"
}

cleanup_dead_panes() {
    init_pane_cache
    local temp_file="${PANE_CACHE_FILE}.tmp"

    while IFS=: read -r idx split pane_id; do
        if tmux list-panes -a -F "#{pane_id}" 2>/dev/null | grep -q "^${pane_id}$"; then
            echo "${idx}:${split}:${pane_id}" >> "$temp_file"
        fi
    done < "$PANE_CACHE_FILE"

    mv "$temp_file" "$PANE_CACHE_FILE" 2>/dev/null || touch "$PANE_CACHE_FILE"
}

sanity_check
ensure_valid_term

# if TS_SEARCH_PATHS is not set use default
[[ -n "$TS_SEARCH_PATHS" ]] || TS_SEARCH_PATHS=(~/ ~/personal ~/personal/dev/env/.config)

# Add any extra search paths to the TS_SEARCH_PATHS array
# e.g : EXTRA_SEARCH_PATHS=("$HOME/extra1:4" "$HOME/extra2")
# note : Path can be suffixed with :number to limit or extend the depth of the search for the Path

if [[ ${#TS_EXTRA_SEARCH_PATHS[@]} -gt 0 ]]; then
    TS_SEARCH_PATHS+=("${TS_EXTRA_SEARCH_PATHS[@]}")
fi

TS_SEARCH_BASES_EXPANDED=()
TS_SEARCH_BASES_DISPLAY=()
TS_SEARCH_BASES_NAME_OVERRIDE=()
TS_EXCLUDE_BASES_EXPANDED=()
TS_EXCLUDE_DEPTHS=()

for entry in "${TS_SEARCH_PATHS[@]}"; do
    if [[ "$entry" == "!"* ]]; then
        exclude_entry="${entry#!}"
        exclude_depth=""
        if [[ "$exclude_entry" =~ ^([^:]+):(-?[0-9]+)(:.+)?$ ]]; then
            raw_base="${BASH_REMATCH[1]}"
            exclude_depth="${BASH_REMATCH[2]}"
        else
            raw_base="$exclude_entry"
        fi

        exclude_depth="${exclude_depth:-${TS_MAX_DEPTH:-1}}"
        expand_search_base "$raw_base"
        TS_EXCLUDE_BASES_EXPANDED+=("${SEARCH_BASE_EXPANDED%/}")
        TS_EXCLUDE_DEPTHS+=("$exclude_depth")
        continue
    fi

    name_override=""
    if [[ "$entry" =~ ^([^:]+):(-?[0-9]+)(:.+)?$ ]]; then
        raw_base="${BASH_REMATCH[1]}"
        depth="${BASH_REMATCH[2]}"
        if [[ -n "${BASH_REMATCH[3]}" && "$depth" -eq 0 ]]; then
            name_override="${BASH_REMATCH[3]#:}"
        fi
    else
        raw_base="$entry"
    fi

    expand_search_base "$raw_base"
    TS_SEARCH_BASES_EXPANDED+=("${SEARCH_BASE_EXPANDED%/}")
    TS_SEARCH_BASES_DISPLAY+=("$SEARCH_BASE_DISPLAY")
    TS_SEARCH_BASES_NAME_OVERRIDE+=("$name_override")
done

# utility function to find directories
find_dirs() {
    # list TMUX sessions
    if [[ -n "${TMUX}" ]]; then
        local current_session
        current_session=$(tmux display-message -p '#S')
        tmux list-sessions -F "#{session_name}" 2>/dev/null | while IFS= read -r session_name; do
            local display_name="[TMUX] $session_name"
            if [[ "$session_name" == "$current_session" ]]; then
                display_name="[TMUX] $session_name (current)"
            fi
            printf '%s\t%s\n' "$display_name" "[TMUX] $session_name"
        done
    else
        tmux list-sessions -F "#{session_name}" 2>/dev/null | while IFS= read -r session_name; do
            printf '%s\t%s\n' "[TMUX] $session_name" "[TMUX] $session_name"
        done
    fi

    # Collect results, then sort + de-dupe once at the end
    local -a results=()

    # note: TS_SEARCH_PATHS is an array of paths to search for directories
    # if the path ends with :number, it will search with that depth.
    # default depth is TS_MAX_DEPTH or 1 if not set
    #
    # Behavior:
    #   depth >= 0: include ONLY git repo roots (dirs that contain a .git dir)
    #   depth <  0: include git repo roots AND non-git directories; use abs(depth)
    #   depth == 0: just return the path itself (still included in non-git mode too)
    for entry in "${TS_SEARCH_PATHS[@]}"; do
        if [[ "$entry" == "!"* ]]; then
            continue
        fi

        local path depth max_depth include_nongit abs_depth
        include_nongit=0

        # Parse "path:depth" suffix (depth may be negative)
        if [[ "$entry" =~ ^([^:]+):(-?[0-9]+)(:.+)?$ ]]; then
            path="${BASH_REMATCH[1]}"
            depth="${BASH_REMATCH[2]}"
        else
            path="$entry"
            depth=""
        fi

        max_depth="${depth:-${TS_MAX_DEPTH:-1}}"

        [[ -d "$path" ]] || continue

        # Negative depth => include non-git dirs too; search depth is abs(depth)
        if [[ "$max_depth" -lt 0 ]]; then
            include_nongit=1
            abs_depth=$(( -max_depth ))
        else
            abs_depth=$max_depth
        fi

        # If depth is 0, just return the path itself
        if [[ "$abs_depth" -eq 0 ]]; then
            results+=("$path")
            continue
        fi

        # Always include git repo roots up to abs_depth
        # repo root at depth d has .git at depth d+1, so search .git up to abs_depth+1
        while IFS= read -r repo_root; do
            [[ -n "$repo_root" ]] && results+=("$repo_root")
        done < <(
            find "$path" \
                -maxdepth "$((abs_depth + 1))" \
                -type d -name .git \
                -exec dirname {} \; 2>/dev/null
        )

        # If include_nongit, include all directories up to abs_depth as well
        if [[ "$include_nongit" -eq 1 ]]; then
            while IFS= read -r d; do
                [[ -n "$d" ]] && results+=("$d")
            done < <(
                find "$path" \
                    -maxdepth "$abs_depth" \
                    -type d \
                    -print 2>/dev/null
            )
        fi
    done

    # Sort and de-duplicate
    if ((${#results[@]})); then
        local -a sorted_results
        mapfile -t sorted_results < <(printf '%s\n' "${results[@]}" | LC_ALL=C sort -u)
        for path in "${sorted_results[@]}"; do
            [[ -n "$path" ]] || continue
            if should_exclude_path "$path"; then
                continue
            fi
            local display
            display=$(build_display_path "$path")
            printf '%s\t%s\n' "$display" "$path"
        done
    fi
}

handle_session_cmd() {
    log "executing session command $session_cmd with index $session_idx split_type=$split_type"
    if ! is_tmux_running; then
        echo "Error: tmux is not running.  Please start tmux first before using session commands."
        exit 1
    fi

    current_session=$(tmux display-message -p '#S')

    if [[ -n "$split_type" ]]; then
        handle_split_session_cmd "$current_session"
    else
        handle_window_session_cmd "$current_session"
    fi
    exit 0
}

handle_window_session_cmd() {
    local current_session="$1"
    start_index=$((69 + $session_idx))
    target="$current_session:$start_index"

    log "target: $target command $session_cmd has-session=$(tmux has-session -t="$target" 2> /dev/null)"
    if tmux has-session -t="$target" 2> /dev/null; then
        switch_to "$target"
    else
        log "executing session command: tmux neww -dt $target $session_cmd"
        tmux neww -dt $target "$session_cmd"
        hydrate "$target" "$selected"
        tmux select-window -t $target
    fi
}

handle_split_session_cmd() {
    local current_session="$1"
    cleanup_dead_panes

    # Check if pane already exists
    local existing_pane_id=$(get_pane_id "$session_idx" "$split_type")

    if [[ -n "$existing_pane_id" ]] && tmux list-panes -a -F "#{pane_id}" 2>/dev/null | grep -q "^${existing_pane_id}$"; then
        log "switching to existing pane $existing_pane_id"
        tmux select-pane -t "$existing_pane_id"
        if [[ -z $TMUX ]]; then
            tmux attach-session -t "$current_session"
        else
            tmux switch-client -t "$current_session"
        fi
    else
        # Create new split
        local split_flag=""
        if [[ "$split_type" == "vsplit" ]]; then
            split_flag="-h"  # horizontal layout (vertical split)
        else
            split_flag="-v"  # vertical layout (horizontal split)
        fi

        log "creating new split: tmux split-window $split_flag -c $(pwd) $session_cmd"
        local new_pane_id=$(tmux split-window $split_flag -c "$(pwd)" -P -F "#{pane_id}" "$session_cmd")

        if [[ -n "$new_pane_id" ]]; then
            set_pane_id "$session_idx" "$split_type" "$new_pane_id"
            log "created pane $new_pane_id for session_idx=$session_idx split_type=$split_type"
        fi
    fi
}

if [[ ! -z $session_cmd ]]; then
    handle_session_cmd
elif [[ ! -z $user_selected ]]; then
    selected="$user_selected"
else
    selected=$(find_dirs | fzf --with-nth=1 --delimiter=$'\t')
fi

if [[ -z $selected ]]; then
    exit 0
fi

if [[ "$selected" == *$'\t'* ]]; then
    selected="${selected#*$'\t'}"
fi

tmux_entry=0
if [[ "$selected" =~ ^\[TMUX\]\ (.+)$ ]]; then
    tmux_entry=1
    selected="${BASH_REMATCH[1]}"
fi

if [[ "$tmux_entry" -eq 1 ]]; then
    selected_name_raw="$selected"
    selected_name="$selected"
else
    selected_name_raw=$(session_name_from_path "$selected")
    selected_name=$(unique_session_name "$selected_name_raw")
fi

log "selected=$selected selected_name_raw=$selected_name_raw selected_name=$selected_name"

if ! ensure_session "$selected_name" "$selected"; then
    exit 1
fi

switch_to "$selected_name"
