#!/bin/bash
# ==============================================================================
# ANA4315 - Introduction to Bioinformatics | Continuous Assessment 1
# Bash Workflow: Automate Repo Clone, Script Execution & CSV Generation
# Repository: https://github.com/sadeeqtheanatomist/BIOINFORMATICS-COLLABORATIVE-PROJECT_GROUP-EIGHTEEN-MEMBERS
# Group: Eighteen
# ==============================================================================
# Step 1: Clone the repository to local machine
echo "=== Cloning Group Eighteen's Repository ==="
git clone https://github.com/sadeeqtheanatomist/BIOINFORMATICS-COLLABORATIVE-PROJECT_GROUP-EIGHTEEN-MEMBERS.git
cd BIOINFORMATICS-COLLABORATIVE-PROJECT_GROUP-EIGHTEEN-MEMBERS || exit  # Exit if folder not found

# Step 2: Create Artifacts folder if it doesn't exist
echo -e "\n=== Setting Up Artifacts Directory ==="
mkdir -p Artifacts  # "-p" ensures no error if folder already exists

# Step 3: Run R script and extract values
echo -e "\n=== Running R Script to Retrieve Details ==="
NAME=$(Rscript script_r.R | grep -E "Full Name :" | sed 's/Full Name : //' | tr -d '\n')
EMAIL=$(Rscript script_r.R | grep -E "Email :" | sed 's/Email : //' | tr -d '\n')
GITHUB_USER=$(Rscript script_r.R | grep -E "GitHub Username :" | sed 's/GitHub Username : //' | tr -d '\n')
SLACK_USER=$(Rscript script_r.R | grep -E "Slack Username :" | sed 's/Slack Username : //' | tr -d '\n')
AREA_INTEREST=$(Rscript script_r.R | grep -E "Area of Interest :" | sed 's/Area of Interest : //' | tr -d '\n')

# Step 4: Generate CSV and save to Artifacts folder
echo -e "\n=== Generating CSV in Artifacts Folder ==="
CSV_FILE="Artifacts/bioinfo_group_eighteen_members.csv"
echo "Name,Email,GitHub Username,Slack Username,Area of Interest" > "$CSV_FILE"
echo "$NAME,$EMAIL,$GITHUB_USER,$SLACK_USER,$AREA_INTEREST" >> "$CSV_FILE"
# Save workflow log to Artifacts
echo "[$(date)] Workflow run successful - CSV generated with 1 member entry" > Artifacts/workflow_run_log.txt


# Step 5: Confirm file location
echo -e "\n=== Workflow Complete! ==="
echo "CSV saved to: $(pwd)/$CSV_FILE"
cat "$CSV_FILE"
