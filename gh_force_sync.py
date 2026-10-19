#!/usr/bin/env python3
# ==============================================================================
# Script Name: gh_force_sync.py
# Description: Automated pipeline recovery tool that force-triggers a fresh,
#              clean workflow execution if recent history errors are caught.
# ==============================================================================

import json
import subprocess

REPO_TARGET = "Colegio-San-Caio/demo-repository"
TARGET_WORKFLOW = "auto.yml"  # Your primary verification environment filename

def recover_pipeline_tree():
    print("================================================================")
    print("     gh-FORCE RECOVERY — AUTOMATED FRESH WORKFLOW DISPATCH       ")
    print("================================================================")
    
    try:
        print(f"[*] Auditing latest history matrix for: {REPO_TARGET}...")
        result = subprocess.run([
            "gh", "run", "list", 
            "--repo", REPO_TARGET, 
            "--json", "status,conclusion", 
            "--limit", "1"
        ], capture_output=True, text=True, check=True)
        
        runs = json.loads(result.stdout)
        
        if not runs:
            print("[-] No workflow execution logs found on remote master.")
            return
            
        latest_run = runs[0]
        status = latest_run.get("status")
        conclusion = latest_run.get("conclusion")
        
        print(f"[*] Current State Log: status={status} | conclusion={conclusion}")
        
        # If the latest finished job ended in a drop/failure context, trigger fresh execution
        if status == "completed" and conclusion == "failure":
            print("[!] Failure state confirmed on remote master branch registry.")
            print(f"[*] Dispatching fresh initialization loop to: {TARGET_WORKFLOW}")
            
            # Fire an explicit workflow dispatch command to trigger a fresh test action
            subprocess.run([
                "gh", "workflow", "run", TARGET_WORKFLOW,
                "--repo", REPO_TARGET
            ], check=True)
            print("[+] Fresh remote recovery workflow successfully triggered!")
        else:
            print("[+] Latest pipeline state passed validation check. No force synchronization needed.")
            
    except subprocess.CalledProcessError as e:
        print(f"[-] GitHub CLI sub-process command rejected: {e}")
    except Exception as err:
        print(f"[-] System runtime exception: {err}")
    print("================================================================")

if __name__ == "__main__":
    recover_pipeline_tree()
