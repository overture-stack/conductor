#!/bin/sh

# Set the base directory for scripts
SCRIPT_DIR="conductor/scripts/services/phase1"

# Debug function for logging
debug() {
    if [ "$DEBUG" = "true" ]; then
        echo "[DEBUG] $1"
    fi
}

# rs = "Run Script" a simple function to apply permissions and run scripts
rs() {
    if [ -f "$1" ]; then
        debug "Found script at: $1"
        debug "Current permissions: $(ls -l "$1")"
        if chmod +x "$1"; then
            debug "Successfully set execute permissions"
            debug "New permissions: $(ls -l "$1")"
            debug "Attempting to execute with sh explicitly..."
            sh "$1"
        else
            echo "Failed to set execute permissions for $1"
            return 1
        fi
    else
        echo "Script not found at: $1"
        return 1
    fi
}

# Welcome
echo -e "\033[1;36m╔══════════════════════════════════════════════════════════╗\033[0m"
echo -e "\033[1;36m║   Spinning up the Prelude Phase One Development Portal   ║\033[0m"
echo -e "\033[1;36m╚══════════════════════════════════════════════════════════╝\033[0m"

# Cleanup any existing healthcheck file
echo -e "\n\033[1;35m[1/7]\033[0m Cleaning up existing health check files"
rs "${SCRIPT_DIR}/healthcheckCleanup.sh"

echo -e "\033[1;36mElasticsearch:\033[0m Starting up (this may take a few minutes)"
rs "${SCRIPT_DIR}/elasticsearchCheck.sh"

# Elasticsearch (File) Setup
echo -e "\n\033[1;35m[2/7]\033[0m Setting up Sample Data in Elasticsearch"
rs "${SCRIPT_DIR}/elasticsearchSetupSampleData.sh"

# Elasticsearch (Tabular) Setup
echo -e "\n\033[1;35m[3/7]\033[0m Setting Summary Data in Elasticsearch"
rs "${SCRIPT_DIR}/elasticsearchSetupSummaryData.sh"

# Elasticsearch (Tabular) Setup
echo -e "\n\033[1;35m[4/7]\033[0m Setting Id Mapping Data in Elasticsearch"
rs "${SCRIPT_DIR}/elasticsearchSetupIdMappingData.sh"

# Update Conductor to Healthy Status
echo -e "\n\033[1;35m[5/7]\033[0m Updating Conductor health status"
echo "healthy" > /health/conductor_health
echo -e "\033[1;36mConductor:\033[0m Updating Container Status. Health check file created"

# Check Stage
echo -e "\n\033[1;35m[6/7]\033[0m Checking Stage"
rs "${SCRIPT_DIR}/stageCheck.sh"

# Check Arranger
echo -e "\n\033[1;35m[7/7]\033[0m Checking Arranger"
rs "${SCRIPT_DIR}/arrangerChecks.sh"

# Remove Health Check File
rm /health/conductor_health
echo -e "\n"

# Success and Next Steps
echo -e "\033[1;36m╔═════════════════════════════════════════════════════════════════╗\033[0m"
echo -e "\033[1;36m║   Prelude Phase One Development Portal running on localhost     ║\033[0m"
echo -e "\033[1;36m╚═════════════════════════════════════════════════════════════════╝\033[0m\n"
echo -e "\033[1m🌐 Development Portal should now be available at:\033[0m\n"
echo -e "   \033[1;32mhttp://localhost:3000\033[0m"
echo -e "   \033[0;90m(unless configured to use a different port)\033[0m\n"
