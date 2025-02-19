#!/bin/sh

ES_AUTH="${ES_USER}:${ES_PASS}"

# Check template file
[ ! -f "$ES_TEMPLATE_FILE_2" ] && printf "\033[1;31mError:\033[0m Template file not found at $ES_TEMPLATE_FILE_2\n" && exit 1

# Set up template if it doesn't exist
printf "\033[1;36mConductor:\033[0m Setting up the Elasticsearch Summary index template\n"
if ! curl -s -u "$ES_AUTH" "$ES_URL/_template/$FILE_ES_TEMPLATE_NAME_2" | grep -q "\"index_patterns\""; then 
   curl -s -u "$ES_AUTH" -X PUT "$ES_URL/_template/$ES_TEMPLATE_NAME_2" \
       -H "Content-Type: application/json" -d @"$ES_TEMPLATE_FILE_2" > /dev/null && \
   printf "\033[1;32mSuccess:\033[0m Elasticsearch Summary index template created successfully\n"
else
   printf "\033[1;36mElasticsearch $INDEX_NAME_2:\033[0m Summary Index template already exists, skipping creation\n"
fi

# Create index with alias if it doesn't exist
printf "\033[1;36mConductor:\033[0m Setting up the Elasticsearch Summary index and alias\n"
if ! curl -s -f -u "$ES_AUTH" -X GET "$ES_URL/$INDEX_NAME_2" > /dev/null 2>&1; then
   printf "\033[1;36mElasticsearch (Summary):\033[0m Index does not exist, creating Summary index\n"
   response=$(curl -s -w "\n%{http_code}" -u "$ES_AUTH" -X PUT "$ES_URL/$INDEX_NAME_2" \
       -H "Content-Type: application/json" \
       -d "{\"aliases\": {\"$ES_ALIAS_NAME_2\": {}}}")
   
   http_code=$(echo "$response" | tail -n1)
   if [ "$http_code" != "200" ] && [ "$http_code" != "201" ]; then
       printf "\033[1;31mError:\033[0m Failed to create Summary index. HTTP Code: $http_code\n"
       exit 1
   fi
   printf "\033[1;32mSuccess:\033[0m Index and alias created\n"
else
   printf "\033[1;36mElasticsearch $INDEX_NAME_2:\033[0m $INDEX_NAME_2 already exists\n"
fi

printf "\033[1;32mSuccess:\033[0m Elasticsearch Summary setup complete\n"