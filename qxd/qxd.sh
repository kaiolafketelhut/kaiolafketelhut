#!/bin/sh
# qxd.sh - tiny QxD interpreter: sh qxd.sh file.iQxD

[ -n "$1" ] || { echo "usage: qxd.sh file.iQxD" >&2; exit 1; }
src=$1
db=$(mktemp) || exit 1
trap 'rm -f "$db"' EXIT
TAB=$(printf '\t')
node=
inmain=0

trim() {
    T=${1#"${1%%[![:space:]]*}"}
    T=${T%"${T##*[![:space:]]}"}
}

unq() {
    U=${1#\"}
    U=${U%\"}
}

store() {
    printf '%s\t%s\t%s\n' "$node" "$1" "$2" >> "$db"
}

# Node[NAME].Field[.sub] -> value
lookup() {
    n=${1#"Node["}
    n=${n%%"]"*}
    f=${1#*"]."}
    while IFS=$TAB read -r kn kf kv; do
        if [ "$kn" = "$n" ] && [ "$kf" = "$f" ]; then
            case $kv in
                *' -> '*) kv=${kv##* -> } ;;
            esac
            unq "$kv"
            printf '%s' "$U"
            return
        fi
    done < "$db"
}

# print "text" Node[X].Field
run_print() {
    rest=$1
    text=
    ref=
    case $rest in
        '"'*)
            s=${rest#\"}
            text=${s%%\"*}
            trim "${s#*\"}"
            ref=$T
            ;;
        *) ref=$rest ;;
    esac
    printf '%s' "$text"
    [ -n "$ref" ] && lookup "$ref"
    printf '\n'
}

while IFS= read -r line || [ -n "$line" ]; do
    trim "$line"
    line=$T
    case $line in
        ''|//*) continue ;;
        "Node["*"] {")
            node=${line#"Node["}
            node=${node%%"]"*}
            continue ;;
        "main {") inmain=1; continue ;;
        "}") node=; inmain=0; continue ;;
    esac

    if [ "$inmain" = 1 ]; then
        case $line in
            'print '*) run_print "${line#print }" ;;
        esac
    elif [ -n "$node" ]; then
        field=${line%%:*}
        value=${line#*:}
        trim "$field"; field=$T
        trim "$value"; value=$T
        store "$field" "$value"
        # { key: val, key: val } also stores Field.key
        case $value in
            "{"*":"*"}")
                inner=${value#"{"}
                inner=${inner%"}"}
                oldifs=$IFS; IFS=,; set -f
                set -- $inner
                set +f; IFS=$oldifs
                for pair; do
                    k=${pair%%:*}; v=${pair#*:}
                    trim "$k"; k=$T
                    trim "$v"; v=$T
                    store "$field.$k" "$v"
                done ;;
        esac
    fi
done < "$src"
