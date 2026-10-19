#!/usr/bin/env python3
# ==============================================================================
# Script Name: verify_git_history.py
# Description: Automated repository audit tool extracting and formatting
#              the complete commit history timeline from the Git branch tree.
# ==============================================================================

import subprocess

def display_repository_audit():
    print("=" * 75)
    print("      MOSFETQ WORKSPACE — REPOSITORY COMMIT LIFECYCLE AUDIT")
    print("=" * 75)
    
    try:
        # Execute standard git log command using optimized formatting arguments
        log_format = "%C(auto)%h %ad | %s (%an)"
        result = subprocess.run(
            ["git", "log", "--graph", f"--oneline", f"--pretty=format:{log_format}", "--date=short"],
            capture_output=True,
            text=True,
            check=True
        )
        
        print(result.stdout)
        print("=" * 75)
        
    except subprocess.CalledProcessError as e:
        print(f"[-] Subprocess tracking failure reading branch logs: {e}")

if __name__ == "__main__":
    display_repository_audit()
