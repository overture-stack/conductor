# ================================================================================== #
#                                                                                    #
#                                    Conductor:                                      #
#                                                                                    #
# ================================================================================== #

# Define all phony targets (targets that don't create files)
.PHONY: dev-phase1 dev-phase2 dev-phase3 dev-stage clean-data reset-volumes load-data generate-configs setup-all down reset generate-phase-one-configs

# Start Phase One development environment
phase1:
	@echo "Starting Phase 1 development environment..."
	PROFILE=phase1 docker compose -f ./docker-compose.yml --profile phase1 up --attach conductor 

# Start Phase Two development environment
phase2:
	@echo "Starting Phase 2 development environment..."
	PROFILE=phase2 docker compose -f ./docker-compose.yml --profile phase2 up --attach conductor

# Start Phase Three development environment
phase3:
	@echo "Starting Phase 3 development environment..."
	PROFILE=phase3 docker compose -f ./docker-compose.yml --profile phase3 up --attach conductor 

# Start Stage development environment
stage-dev:
	@echo "Starting Stage development environment..."
	PROFILE=stageDev docker compose -f ./docker-compose.yml --profile stageDev up --attach conductor

# Load sample data into Elasticsearch
load-data:
	@echo "Loading sample data into Elasticsearch..."
	PROFILE=phaseOneSubmission docker compose -f ./docker-compose.yml --profile phaseOneSubmission up --attach composer

# Shutdown all containers while preserving volumes
down:
	@echo "Shutting down all running containers..."
	PROFILE=default docker compose -f ./docker-compose.yml --profile default down

# Shutdown all containers and remove all volumes (WARNING: Deletes all data)
reset:
	@echo "\033[1;33mWarning:\033[0m This will remove all containers AND their volumes. Data will be lost."
	@read -p "Are you sure you want to continue? [y/N] " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		PROFILE=default docker compose -f ./docker-compose.yml --profile default down -v ; \
	else \
		echo "Operation cancelled"; \
	fi

# ================================================================================== #
#                                                                                    #
#                                    Composer:                                       #
#                                                                                    #
# ================================================================================== #

# Generate Phase One Configurations (Elasticsearch Mapping and Arranger Configs)
generate-phase-one-configs:
	@echo "Generating Phase One Configurations..."
	PROFILE=generatePhaseOneConfigs docker compose -f ./docker-composer.yml --profile generatePhaseOneConfigs up

default:
	@echo "Spinning up in default mode..."
	PROFILE=default docker compose -f ./docker-composer.yml --profile default up
