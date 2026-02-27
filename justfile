# Auto load variables defined in .env file
set dotenv-load := true
# Just will fail if there is no .env file available
set dotenv-required := true

project_root := justfile_directory()

db_port := env('POSTGRES_PORT', '5432')
db_username := env('POSTGRES_USER', '')
db_password := env('POSTGRES_PASSWORD', '')
db_database_name := env('POSTGRES_DB', '')
db_connection_string := f'db:pg://{{db_username}}:{{db_password}}@localhost:{{db_port}}/{{db_database_name}}'

test_db_port := env('TEST_POSTGRES_PORT', '5433')
test_db_username := env('TEST_POSTGRES_USER', '')
test_db_password := env('TEST_POSTGRES_PASSWORD', '')
test_db_database_name := env('TEST_POSTGRES_DB', '')
test_db_connection_string := f'db:pg://{{test_db_username}}:{{test_db_password}}@localhost:{{test_db_port}}/{{test_db_database_name}}'

[positional-arguments]
sqitch *args='':
  {{project_root}}/docker_sqitch.sh "$@" {{ db_connection_string }}

[positional-arguments]
sqitch_test *args='':
  {{project_root}}/docker_sqitch.sh "$@" {{ test_db_connection_string }}

# Local DB recipes

start_db:
  docker compose up -d db # No-op if the db service is already running
  just sqitch deploy --verify

revert_db:
  just sqitch revert

stop_db:
  docker compose stop db # Just stop the db container

reset_db:
  docker compose down --volumes db # Remove the db container with its volume
  just start_db


# Test recipes

start_test_db:
  docker compose up -d test_db
  just sqitch_test deploy --verify

revert_test_db:
  just sqitch_test revert

stop_test_db:
  docker compose stop test_db

reset_test_db:
  docker compose down --volumes test_db
  just start_test_db
