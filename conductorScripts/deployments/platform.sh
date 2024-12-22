#!/bin/sh

# Welcome
echo -e "\033[1;36m╔════════════════════════════════════════════════╗\033[0m"
echo -e "\033[1;36m║   Spinning up the Prelude Development Portal   ║\033[0m"
echo -e "\033[1;36m╚════════════════════════════════════════════════╝\033[0m\n"

# rs = "Run Script" a simple function to apply permissions and run scripts
rs() {
        chmod +x "$1" && "$1"
    }

# Cleanup any existing healthcheck file
rs scripts/services/healthcheckCleanup.sh

# Wait a bit for Elasticsearch 
echo -e "\033[1;36mElasticsearch:\033[0m Starting up (this may take a few minutes)"
until curl -s -u elastic:myelasticpassword -X GET "http://elasticsearch:9200/_cluster/health" > /dev/null; do
    echo -e "\033[1;36mElasticsearch:\033[0m Not yewt reachable, checking again in 30 seconds"
    sleep 30
done
echo -e "\033[1;32mSuccess:\033[0m Elasticsearch is reachable"

# Elasticsearch (Compp) Setup
echo -e "\033[1;35m[1/4]\033[0m Setting up Composition Data in Elasticsearch"
rs /scripts/services/elasticsearchSetupCompositionData.sh

# Elasticsearch (Instrument) Setup
echo -e "\033[1;35m[2/4]\033[0m Setting Instrument Data in Elasticsearch"
rs /scripts/services/elasticsearchSetupInstrumentData.sh

# Update Conductor to Healthy Status, this signals search and exploration services (maestro, arranger, stage) to startup
echo "healthy" > /health/conductor_health
echo -e  "\033[1;36mConductor:\033[0m Updating Container Status. Health check file created"

# Check Stage
echo -e "\033[1;35m[3/4]\033[0m Checking Stage"
rs /scripts/services/stageCheck.sh

# Check Arranger
echo -e "\033[1;35m[4/4]\033[0m Checking Arranger"
rs /scripts/services/arrangerCheck.sh

# Remove Health Check File 
rm /health/conductor_health

# Success and Next Steps
echo -e "\033[1;36m╔═══════════════════════════════════════════════════════╗\033[0m"
echo -e "\033[1;36m║   Prelude Development Portal running on localhost     ║\033[0m"
echo -e "\033[1;36m╚═══════════════════════════════════════════════════════╝\033[0m\n"
echo -e "\033[1m🌐 Development Portal should now be available at:\033[0m\n"
echo -e "   \033[1;32mhttp://localhost:3000\033[0m"
echo -e "   \033[0;90m(unless configured to use a different port)\033[0m\n"