# Auto load variables defined in .env file
set dotenv-load := true
# Just will fail if there is no .env file available
set dotenv-required := true

rootDir := justfile_directory()
waitTime := "5" # Time to wait for the db to be ready in seconds, this is a bit of a hack but it works, ideally we would have some sort of health check here instead of just waiting a fixed amount of time

set dotenv-path := './backend/.env'

db_port := env('POSTGRES_PORT', '5432')
db_username := env('POSTGRES_USER', '')
db_password := env('POSTGRES_PASSWORD', '')
db_database_name := env('POSTGRES_DB', '')
db_connection_string := f'db:pg://{{db_username}}:{{db_password}}@localhost:{{db_port}}/{{db_database_name}}'

# The .env file no longer contains test-specific env variables; those have been moved to .env.test. Why? For code reuse. By moving the test variables into their own .env.test file, we can reuse the same names as what we have in .env, meaning our code to load the variables won't need to change between environments. The only issue with this is Justfiles don't support loading multiple .env files, so we must resort to a bit of duplication, copying the env values in .env.test here so the recipes defined here for testing can keep working. I considered going down the module approach, creating a separate Just module for test recipes, but Just doesn't support loading different .env files across modules either. I could also create a totally separate justfile just for test recipes, but that would result in much more duplication than what we have here.
# REMEMBER TO UPDATE THESE VALUES AS .env.test CHANGES
test_db_port := '5433'
test_db_username := 'village_test'
test_db_password := 'passwordTest'
test_db_database_name := 'village_test'
test_db_connection_string := f'db:pg://{{test_db_username}}:{{test_db_password}}@localhost:{{test_db_port}}/{{test_db_database_name}}'

[positional-arguments, private]
docker_sqitch *args='':
  #!/usr/bin/env bash
  # This script allows us to run sqitch in a docker container, so we don't have to install it on our local machine.
  docker run -it --rm --network host \
  	-v "$(pwd)/db/sqitch:/repo" \
  	-u "$(id -u):$(id -g)" \
  	sqitch/sqitch "$@"

[positional-arguments]
@sqitch *args='':
  just docker_sqitch "$@" {{ db_connection_string }}

[positional-arguments]
@sqitch_test *args='':
  just docker_sqitch "$@" {{ test_db_connection_string }}

# Local DB recipes

startup_db:
  docker compose up -d db # No-op if the db service is already running
  sleep {{waitTime}}
  just deploy_db

deploy_db:
  just sqitch deploy --verify

revert_db:
  just sqitch revert

stop_db:
  docker compose stop db # Just stop the db container

shutdown_db:
  docker compose down -v db # Stops and removes the db container, -v is --volumes which removes the db data volume as well, effectively resetting the db to a clean slate

restart_db:
  docker compose restart db

reset_db:
  just revert_and_shutdown_db
  sleep {{waitTime}}
  just startup_db

revert_and_shutdown_db:
  just revert_db
  just shutdown_db

db_ui:
  rainfrog  --url 'postgres://{{db_username}}:{{db_password}}@localhost:{{db_port}}/{{db_database_name}}'


# Test recipes

startup_test_db:
  docker compose up -d test_db
  sleep {{waitTime}}
  just deploy_test_db

deploy_test_db:
  just sqitch_test deploy --verify

revert_test_db:
  just sqitch_test revert

stop_test_db:
  docker compose stop test_db

shutdown_test_db:
  docker compose down -v test_db

restart_test_db:
  docker compose restart test_db

reset_test_db:
  just revert_and_shutdown_test_db
  sleep {{waitTime}}
  just startup_test_db

revert_and_shutdown_test_db:
  just revert_test_db
  just shutdown_test_db

test_db_ui:
  rainfrog  --url 'postgres://{{test_db_username}}:{{test_db_password}}@localhost:{{test_db_port}}/{{test_db_database_name}}'
