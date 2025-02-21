#!/bin/sh

# Configuration
CONDUCTOR_PATH="${CONDUCTOR_PATH:-/conductor}"

# Validate and prepare data files and index names
validate_and_prepare_inputs() {
    # Remove spaces from environment variables
    DATA_FILES=$(echo "$DATA_FILES" | tr -d ' ')
    INDEX_NAMES=$(echo "$INDEX_NAMES" | tr -d ' ')

    # Count the number of files and indices
    DATA_FILES_COUNT=$(echo "$DATA_FILES" | awk -F, '{print NF}')
    INDEX_NAMES_COUNT=$(echo "$INDEX_NAMES" | awk -F, '{print NF}')

    # Validate input arrays have equal length
    if [ "$DATA_FILES_COUNT" -ne "$INDEX_NAMES_COUNT" ]; then
        echo -e "\033[1;31mError:\033[0m Mismatch between DATA_FILES and INDEX_NAMES"
        exit 1
    fi

    # Validate each file exists
    IFS=','
    for file in $DATA_FILES; do
        if [ ! -f "$file" ]; then
            echo -e "\033[1;31mError:\033[0m Data file not found at $file"
            exit 1
        fi
    done
    unset IFS
}

# Main script execution
main() {
    echo -e "\033[1;36mConductor:\033[0m Setting up elasticsearch ETL utility"

    # Validate inputs
    validate_and_prepare_inputs

    # Install dependencies
    echo -e "\033[1;35m[1/2]\033[0m Installing Conductor dependencies"
    cd $CONDUCTOR_PATH && npm install --silent || {
        echo -e "\033[1;31mError:\033[0m Failed to install dependencies"
        exit 1
    }

    # Submit data for each file
    echo -e "\033[1;35m[2/2]\033[0m Submitting tabular data to Elasticsearch"
    
    # Use IFS to correctly handle comma-separated lists
    IFS=','
    FILE_INDEX=0
    for file in $DATA_FILES; do
        # Get corresponding index name
        INDEX_NAME=$(echo "$INDEX_NAMES" | cut -d',' -f$((FILE_INDEX+1)))

        # Submit data using npx
        npx ts-node src/main.ts -f "$file" -i "$INDEX_NAME" --url "$ES_URL" || {
            echo -e "\033[1;31mError:\033[0m Failed to submit data to Elasticsearch index $INDEX_NAME"
            exit 1
        }

        echo -e "\033[1;32m✓\033[0m Submitted $file to $INDEX_NAME"
        FILE_INDEX=$((FILE_INDEX+1))
    done
    unset IFS
}

# Execute main function
main