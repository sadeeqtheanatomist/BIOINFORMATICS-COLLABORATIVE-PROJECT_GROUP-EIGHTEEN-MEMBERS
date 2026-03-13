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

# Step 2: Run R script and capture output
echo -e "\n=== Running R Script to Retrieve Details ==="
OUTPUT=$(Rscript script_r.R)

# Step 3: Generate structured CSV file
echo -e "\n=== Generating CSV Output ==="
CSV_FILE="bioinfo_group_eighteen.csv"
echo "Name,Email,Slack Username,GitHub Username,Area of Interest" > "$CSV_FILE"
echo "$OUTPUT" | tr '\n' ',' | sed 's/,$/\n/' >> "$CSV_FILE"  # Fix: Removes trailing comma

# Step 4: Confirm success and show output
echo -e "\n=== Workflow Complete! CSV File Content ==="
cat "$CSV_FILE"
