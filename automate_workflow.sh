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
 # Step 2: Run R script and extract ONLY values (remove labels)
 echo -e "\n=== Running R Script to Retrieve Details ==="
 NAME=$(Rscript script_r.R | grep -E "Full Name :" | sed 's/Full Name : //' | tr -d '\n')
 EMAIL=$(Rscript script_r.R | grep -E "Email :" | sed 's/Email : //' | tr -d '\n')
 GITHUB_USER=$(Rscript script_r.R | grep -E "GitHub Username :" | sed 's/GitHub Username : //' | tr -d '\n')
 SLACK_USER=$(Rscript script_r.R | grep -E "Slack Username :" | sed 's/Slack Username : //' | tr -d '\n')
 AREA_INTEREST=$(Rscript script_r.R | grep -E "Area of Interest :" | sed 's/Area of Interest : //' | tr -d '\n')
 # Step 3: Generate structured CSV file
 echo -e "\n=== Generating CSV Output ==="
 CSV_FILE="bioinfo_group_eighteen.csv"
 echo "Name,Email,GitHub Username,Slack Username,Area of Interest" > "$CSV_FILE"
 echo "$NAME,$EMAIL,$GITHUB_USER,$SLACK_USER,$AREA_INTEREST" >> "$CSV_FILE"
 # Step 4: Confirm success and show output
 echo -e "\n=== Workflow Complete! CSV File Content ==="
 cat "$CSV_FILE"