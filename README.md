# recipe-app-api
## required steps
- configure [docker hub](https://hub.docker.com/settings/security) with access token for [github project](https://github.com/RobertVenhryn/recipe-app-api/settings/secrets/actions/new)
- to run flake8 testing:
  ```shell
  docker compose build
  docker compose run --rm app sh -c "flake8"
  ```
- initialize the project inside app directory using django cli (the files are synced between the container and our app folder):
  ```shell
  docker compose run --rm app sh -c "django-admin startproject app ."
  ```
- run and see in the [browser](http://localhost:8000/):
  ```shell
  docker compose up
  ```
- run tests
  ```shell
  docker compose run --rm app sh -c "python manage.py test"
  ```
- create core app to configure our application to wait postgresql db until it starts
  ```shell
  docker compose run --rm app sh -c "python manage.py startapp core"
  ```
- create migrations for the custom user model that we added to the project.
  do not modify the migration file (0001_initial.py)
  ```shell
  docker compose run --rm app sh -c "python manage.py makemigrations"
  ```
- apply the migrations to the project
  ```shell
  docker compose run --rm app sh -c "python manage.py wait_for_db && python manage.py migrate"
  ```
  this will output `Migration admin.0001_initial is applied before its dependency core.0001_initial on database 'default'.` because we applied the migrations previously with default django user model. We need to clear the data in db.
  ```shell
  docker volume ls
  docker volume rm recipe-app-api_dev-db-data
  docker compose run --rm app sh -c "python manage.py wait_for_db && python manage.py migrate"
  ```

