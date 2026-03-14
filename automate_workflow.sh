#!/bin/bash
# ==============================================================================
# ANA4315 - Introduction to Bioinformatics | Continuous Assessment 1
# Bash Workflow: Automate Repo Clone, Script Execution & CSV Generation
# Repository: https://github.com/sadeeqtheanatomist/BIOINFORMATICS-COLLABORATIVE-PROJECT_GROUP-EIGHTEEN-MEMBERS
# Group: Eighteen
# ==============================================================================

# --------------------------
# Step 0: Dependency Checks & Options
# --------------------------
# Check for required software
if ! command -v git &> /dev/null; then
  echo "ERROR: 'git' is not installed. Please install git first."
  exit 1
fi

if ! command -v Rscript &> /dev/null; then
  echo "ERROR: 'Rscript' is not installed. Please install R first."
  exit 1
fi

# Handle cleanup option
CLEAN_CLONE=false
while getopts "c" opt; do
  case $opt in
    c) CLEAN_CLONE=true ;;
    *) echo "Usage: $0 [-c] (use -c to delete existing repository before cloning)" && exit 1 ;;
  esac
done


# --------------------------
# Step 1: Clone Repository
# --------------------------
echo "=== Cloning Group Eighteen's Repository ==="
if [ "$CLEAN_CLONE" = true ]; then
  rm -rf BIOINFORMATICS-COLLABORATIVE-PROJECT_GROUP-EIGHTEEN-MEMBERS
  echo "✅ Existing repository folder deleted"
fi

git clone https://github.com/sadeeqtheanatomist/BIOINFORMATICS-COLLABORATIVE-PROJECT_GROUP-EIGHTEEN-MEMBERS.git
cd BIOINFORMATICS-COLLABORATIVE-PROJECT_GROUP-EIGHTEEN-MEMBERS || {
  echo "ERROR: Failed to enter repository folder"
  exit 1
}
echo "✅ Repository cloned and accessed successfully"


# --------------------------
# Step 2: Set Up Artifacts Directory
# --------------------------
echo -e "\n=== Setting Up Artifacts Directory ==="
mkdir -p Artifacts
echo "✅ Artifacts folder ready (created or already exists)"


# --------------------------
# Step 3: Run R Script & Extract Details
# --------------------------
echo -e "\n=== Running R Script to Retrieve Details ==="
if [ ! -f "script_r.R" ]; then
  echo "ERROR: R script 'script_r.R' not found in repository"
  echo "[$(date)] Error: Missing R script file" > Artifacts/workflow_run_log.txt
  exit 1
fi

# Capture R script output once for efficiency
R_OUTPUT=$(Rscript script_r.R)

# Extract values with cleanup
NAME=$(echo "$R_OUTPUT" | grep -E "Full Name :" | sed 's/Full Name : //' | tr -d '\r\n')
MATRIC_NO="BASUG/UG/BMS/ANA/22/5377"
EMAIL=$(echo "$R_OUTPUT" | grep -E "Email :" | sed 's/Email : //' | tr -d '\r\n')
GITHUB_USER=$(echo "$R_OUTPUT" | grep -E "GitHub Username :" | sed 's/GitHub Username : //' | tr -d '\r\n')
SLACK_USER=$(echo "$R_OUTPUT" | grep -E "Slack Username :" | sed 's/Slack Username : //' | tr -d '\r\n')
AREA_INTEREST=$(echo "$R_OUTPUT" | grep -E "Area of Interest :" | sed 's/Area of Interest : //' | tr -d '\r\n')

# Validate extracted data
if [ -z "$NAME" ] || [ -z "$EMAIL" ]; then
  echo "ERROR: Failed to extract core member details"
  echo "R Script Output: $R_OUTPUT" > Artifacts/r_script_error_log.txt
  echo "[$(date)] Error: Missing core member data" > Artifacts/workflow_run_log.txt
  exit 1
fi
echo "✅ Member details extracted successfully"


# --------------------------
# Step 4: Generate CSV & Logs
# --------------------------
echo -e "\n=== Generating CSV in Artifacts Folder ==="
CSV_FILE="Artifacts/bioinfo_group_eighteen_members.csv"

# Write CSV content
echo "Name,Matriculation Number,Email,GitHub Username,Slack Username,Area of Interest" > "$CSV_FILE"
echo "$NAME,$MATRIC_NO,$EMAIL,$GITHUB_USER,$SLACK_USER,$AREA_INTEREST" >> "$CSV_FILE"

# Write detailed workflow log
{
  echo "[$(date)] Workflow completed successfully"
  echo "Repository Path: $(pwd)"
  echo "CSV File Path: $(pwd)/$CSV_FILE"
  echo -e "\nExtracted Member Details:"
  echo "Name: $NAME"
  echo "Matriculation Number: $MATRIC_NO"
  echo "Email: $EMAIL"
  echo "GitHub Username: $GITHUB_USER"
  echo "Slack Username: $SLACK_USER"
  echo "Area of Interest: $AREA_INTEREST"
} > Artifacts/workflow_run_log.txt
echo "✅ CSV and log files generated"


# --------------------------
# Step 5: Display Confirmation
# --------------------------
echo -e "\n=== WORKFLOW COMPLETE! ==="
echo "CSV File Location: $(pwd)/$CSV_FILE"
echo -e "\nCSV Content Preview:"
cat "$CSV_FILE"
