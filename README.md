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
