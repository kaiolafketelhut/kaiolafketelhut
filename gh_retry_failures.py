#!/usr/bin/env python3
# ==============================================================================
# Script Name: gh_retry_failures.py
# Description: Automatically detects recent failed GitHub Actions workflow runs
#              for the repository and triggers a secure programmatic re-run.
# ==============================================================================

import json
import subprocess

REPO_TARGET = "Colegio-San-Caio/demo-repository"

def repair_failed_pipelines():
    print("================================================================")
    echo_msg = "     gh-RETRY AUTOMATION — ISOLATING WORKFLOW RUN FAILURES      "
    print(echo_msg)
    print("================================================================")
    
    try:
        # 1. Fetch recent runs in raw JSON format to parse state values safely
        print(f"[*] Querying recent workflow states for: {REPO_TARGET}...")
        result = subprocess.run([
            "gh", "run", "list", 
            "--repo", REPO_TARGET, 
            "--json", "databaseId,status,conclusion", 
            "--limit", "15"
        ], capture_output=True, text=True, check=True)
        
        runs = json.loads(result.stdout)
        failure_count = 0
        
        # 2. Iterate through execution states to isolate failures
        for run in runs:
            run_id = run.get("databaseId")
            status = run.get("status")
            conclusion = run.get("conclusion")
            
            if status == "completed" and conclusion == "failure":
                failure_count += 1
                print(f"[!] Discovered execution failure -> Run ID: {run_id}")
                print(f"    [*] Issuing remote re-run directive via GitHub API context...")
                
                # 3. Trigger remote rerun using gh CLI wrappers
                subprocess.run([
                    "gh", "run", "rerun", str(run_id), 
                    "--repo", REPO_TARGET
                ], check=True)
                print(f"    [+] Re-run triggered successfully for ID: {run_id}\n")
                
        if failure_count == 0:
            print("[+] Zero workflow failures found. Complete pipeline tree is stable!")
        else:
            print(f"[+] Operational repair loop complete. Triggered {failure_count} re-runs.")
            
    except subprocess.CalledProcessError as e:
        print(f"[-] GitHub CLI execution error: {e}")
    except Exception as err:
        print(f"[-] Infrastructure transport exception: {err}")
    print("================================================================")

if __name__ == "__main__":
    repair_failed_pipelines()
