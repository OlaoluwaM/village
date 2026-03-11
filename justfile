# Auto load variables defined in .env file
set dotenv-load := true
# Just will fail if there is no .env file available
set dotenv-required := true

rootDir := justfile_directory()

db_port := env('POSTGRES_PORT', '5432')
db_username := env('POSTGRES_USER', '')
db_password := env('POSTGRES_PASSWORD', '')
db_database_name := env('POSTGRES_DB', '')
db_connection_string := f'db:pg://{{db_username}}:{{db_password}}@localhost:{{db_port}}/{{db_database_name}}'

# The .env file no longer contains test specific env variables, those have been moved .env.test. Why? For code reuse. By moving the test variables into their own .env.test file we can reuse the same names as what we have in .env meaning our code to load the variables won't need to change between environments. The only issue with this is justfiles don't support loading multiple .env files hence, we must resort to a bit of duplication, copying the env values in .env.test here so the recipes defined here for testing can keep working. I considered going down the module approach, create a separate just module for test recipes but just doesn't support loading different .env files across modules wither. I could also create a totally separate justfile just for test recipes, but that would result in much more duplication than what we have here.
# REMEMBER TO UPDATE THESE VALUES AS .env.test CHANGES
test_db_port := '5433'
test_db_username := 'village-test'
test_db_password := 'password'
test_db_database_name := 'village-test'
test_db_connection_string := f'db:pg://{{test_db_username}}:{{test_db_password}}@localhost:{{test_db_port}}/{{test_db_database_name}}'

[positional-arguments, private]
docker_sqitch *args='':
  #!/usr/bin/env bash
  # This script allows us run sqitch in a docker container, so we don't have to install it on our local machine.
  docker run -it --rm --network host \
  	-v "$(pwd)/db/sqitch:/repo" \
  	-u "$(id -u ${USER}):$(id -g ${USER})" \
  	"${passopt[@]}" sqitch/sqitch "$@"

[positional-arguments]
@sqitch *args='':
  just docker_sqitch "$@" {{ db_connection_string }}

[positional-arguments]
@sqitch_test *args='':
  just docker_sqitch "$@" {{ test_db_connection_string }}

# Local DB recipes

start_db:
  docker compose up -d db # No-op if the db service is already running
  just deploy_db

deploy_db:
  just sqitch deploy --verify

revert_db:
  just sqitch revert

restart_db:
  docker compose restart db

reset_db:
  just clean_and_stop_db
  just start_db

stop_db:
  docker compose stop db # Just stop the db container

clean_and_stop_db:
  just revert_db
  docker compose rm --stop --force -v db # Remove the db container

db_ui:
  rainfrog  --url 'postgres://{{db_username}}:{{db_password}}@localhost:{{db_port}}/{{db_database_name}}'


# Test recipes

start_test_db:
  docker compose up -d test_db
  just deploy_test_db

deploy_test_db:
  just sqitch_test deploy --verify

revert_test_db:
  just sqitch_test revert

restart_test_db:
  docker compose restart test_db

reset_test_db:
  just clean_and_stop_test_db
  just start_test_db

stop_test_db:
  docker compose stop test_db

clean_and_stop_test_db:
  just revert_test_db
  docker compose rm --stop --force -v test_db # Remove the db container

test_db_ui:
  rainfrog  --url 'postgres://{{test_db_username}}:{{test_db_password}}@localhost:{{test_db_port}}/{{test_db_database_name}}'
