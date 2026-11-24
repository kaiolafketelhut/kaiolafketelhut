all:
	@cat canary.json | python3 -m json.tool | grep -E "kdp|BOA|IANA|PORT|total_flops"
	@ls -lh canary.json icon-canary.png push.json 2>/dev/null
	@echo "=== ALL KAIOS 84 flops ==="

json:
	@python3 -m json.tool canary.json > /dev/null && echo "✅ canary.json valid 84 flops"

canary: canary.json icon-canary.png
	@echo "=== CANARY BUILD ==="
	@cat canary.json | python3 -m json.tool
	@zip -r boa84-canary.zip canary.json push.json icon-canary.png 2>/dev/null; echo "✅ boa84-canary.zip"

push: canary.json push.json
	@cat push.json | python3 -m json.tool > /dev/null
	@echo "Pushing async to GitHub..."
	@cd ~/probable-train && cp ~/kai/canary.json ./KaiOS-canary.json && cp ~/kai/push.json ./push.json && git add KaiOS-canary.json push.json && git commit -m "canary: async push 84 flops KDP KL5UQ4f48673352 $$(date)" && git push origin main
	@echo "✅ Async push done - GitHub Actions will build now!"

serve:
	python3 -m http.server 8038

clean:
	rm -f boa84-*.zip
