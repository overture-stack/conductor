#!/bin/sh
        
# Create missing empty directories not tracked by git and needed by postgres
echo -e "\033[1;35m[2/10]\033[0m Setting up empty directories for Keycloaks postgres database"
mkdir -p keycloak/db-folder-init/pg_tblspc
mkdir -p keycloak/db-folder-init/pg_stat
mkdir -p keycloak/db-folder-init/pg_replslot
mkdir -p keycloak/db-folder-init/pg_dynshmem
mkdir -p keycloak/db-folder-init/pg_twophase
mkdir -p keycloak/db-folder-init/pg_notify
mkdir -p keycloak/db-folder-init/pg_serial
mkdir -p keycloak/db-folder-init/pg_snapshots
mkdir -p keycloak/db-folder-init/pg_commit_ts
mkdir -p keycloak/db-folder-init/pg_wal/archive_status
mkdir -p keycloak/db-folder-init/pg_logical/snapshots
mkdir -p keycloak/db-folder-init/pg_logical/mappings
echo -e "\033[1;32mSuccess:\033[0m Keycloak Databases ready"
