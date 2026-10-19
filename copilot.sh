#!/data/data/com.termux/files/usr/bin/bash

cat <<'EOF'

========================================
COPILOT DEPLOYMENT LESSONS
========================================

Lesson #1
----------
A successful git push does not guarantee that the deployed content
matches the expected content.

Always verify the deployed result.

Lesson #2
----------
Expected deployed content:

<h1>v6.3 bunq.me - No API Key</h1>
<p>Free business = no dev key. Use bunq.me link, not API.</p>
<p>Sandbox: public-api.sandbox.bunq.com/v1/
| Prod: api.bunq.com/v1/
| Both need key = 404 without key is normal</p>
<a href="https://bunq.me">Get your bunq.me</a>

Always verify deployments using hashes or content comparison.

Examples:

sha256sum index.html

curl -sL "https://colegio-san-caio.github.io/demo-repository/index.html?ts=$(date +%s)" \
| sha256sum

or

curl -sL "https://colegio-san-caio.github.io/demo-repository/index.html?ts=$(date +%s)" \
| head -20

Lesson #3
----------
curl -I is useful for checking HTTP headers and caching behavior.

Example:

curl -I "https://colegio-san-caio.github.io/demo-repository/index.html"

Useful fields:

  HTTP/2 200
  cache-control
  age
  x-cache
  last-modified
  etag

Deployment Rule
---------------
Trust:
  HASH > ASSUMPTION

Verify:
  Local Hash  == Remote Hash
  Local Content == Remote Content

Only then declare deployment successful.

EOF

