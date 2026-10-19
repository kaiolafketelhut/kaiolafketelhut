#!/bin/bash
# Lists public repos of the org and the personal account, with latest releases, as an HTML fragment
set -e
OUT=${1:-repos.html}
SOURCES="orgs/Colegio-San-Caio users/clevjhon"
EXCLUDE=""   # repo names to hide, space-separated

list() {
  local owner=$1 kind=$2
  printf '<h3>%s</h3>\n' "$owner"
  gh api "$kind/$owner/repos?per_page=100" --paginate \
    --jq '.[] | select(.archived == false and .private == false and .fork == false) | [.name, .html_url, (.description // "")] | @tsv' \
    | sort | while IFS=$'\t' read -r name url desc; do
      case " $EXCLUDE " in *" $name "*) continue ;; esac
      printf '<h4><a href="%s">%s</a></h4>\n' "$url" "$name"
      [ -n "$desc" ] && printf '<p class="small">%s</p>\n' "$(printf '%s' "$desc" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')"
      rel=$(gh api "repos/$owner/$name/releases?per_page=5" --jq '.[] | "<li><a href=\"" + .html_url + "\">" + ((.name // .tag_name) | @html) + "</a> (" + (.tag_name | @html) + ", " + .published_at[0:10] + ")</li>"' 2>/dev/null || true)
      if [ -n "$rel" ]; then printf '<ul>\n%s\n</ul>\n' "$rel"; else echo '<p class="small">No releases yet.</p>'; fi
    done
}

{
echo '<h2>Repositories and releases</h2>'
for s in $SOURCES; do list "${s#*/}" "${s%%/*}"; done
} > "$OUT"
