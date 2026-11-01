# qxd.awk - tiny QxD interpreter: awk -f qxd.awk file.iQxD

function trim(s) {
    sub(/^[ \t\r]+/, "", s)
    sub(/[ \t\r]+$/, "", s)
    return s
}

function unq(s) {
    sub(/^"/, "", s)
    sub(/"$/, "", s)
    return s
}

# Node[NAME].Field[.sub] -> value
function lookup(ref,    n, f, v, i) {
    i = index(ref, "].")
    if (substr(ref, 1, 5) != "Node[" || i == 0) return ""
    n = substr(ref, 6, i - 6)
    f = substr(ref, i + 2)
    if (!((n, f) in db)) return ""
    v = db[n, f]
    while ((i = index(v, " -> ")) > 0) v = substr(v, i + 4)
    return unq(v)
}

# print "text" Node[X].Field
function run_print(rest,    text, ref, q) {
    text = ""
    ref = rest
    if (substr(rest, 1, 1) == "\"") {
        rest = substr(rest, 2)
        q = index(rest, "\"")
        text = substr(rest, 1, q - 1)
        ref = trim(substr(rest, q + 1))
    }
    printf "%s%s\n", text, (ref == "" ? "" : lookup(ref))
}

{
    line = trim($0)
    if (line == "" || substr(line, 1, 2) == "//") next
    if (line ~ /^Node\[.*\] \{$/) {
        node = substr(line, 6)
        sub(/\].*$/, "", node)
        next
    }
    if (line == "main {") { inmain = 1; next }
    if (line == "}")      { node = ""; inmain = 0; next }

    if (inmain) {
        if (substr(line, 1, 6) == "print ") run_print(substr(line, 7))
        next
    }
    if (node == "") next

    c = index(line, ":")
    if (c == 0) next
    field = trim(substr(line, 1, c - 1))
    value = trim(substr(line, c + 1))
    db[node, field] = value

    # { key: val, key: val } also stores Field.key
    if (value ~ /^\{.*:.*\}$/) {
        inner = substr(value, 2, length(value) - 2)
        cnt = split(inner, pairs, ",")
        for (j = 1; j <= cnt; j++) {
            p = index(pairs[j], ":")
            if (p == 0) continue
            db[node, field "." trim(substr(pairs[j], 1, p - 1))] = trim(substr(pairs[j], p + 1))
        }
    }
}
