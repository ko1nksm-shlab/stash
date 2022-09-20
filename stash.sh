# shellcheck shell=sh

STASH=0 STASH_i=1

stash_push() {
    if [ "${1:-}" = "+" ]; then
        shift
        STASH="${STASH%:*}:$((${STASH##*:} + $#))"
    else
        STASH="$STASH:$#"
    fi
    while [ $# -gt 0 ]; do
        eval "STASH_$STASH_i=$1\${$1+:}\${$1:-}"
        STASH_i=$((STASH_i + 1))
        shift
    done
}

stash_pop() {
    set -- "${1:-0}" $((STASH_i - ${STASH##*:}))
    while [ "$STASH_i" -gt "$2" ]; do
        STASH_i=$((STASH_i - 1))
        eval "set -- \"\$1\" \"\$2\" \"\$STASH_$STASH_i\""
        case $3 in
            *:*) eval "${3%%:*}=\${3#*:}" ;;
            *) unset "$3" ;;
        esac
        unset "STASH_$STASH_i"
    done
    STASH="${STASH%:*}"
    return "$1"
}
