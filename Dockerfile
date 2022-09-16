FROM python:3.9-alpine3.13
LABEL maintainer="roboman341@gmail.com"

#print the output directly to the terminal and do not buffer
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

#We are not using dev by default. It'll be overwriten by docker-compose file
ARG DEV=false

RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    # the client packages we need to install for psycopg2 (to connect django and postgresq)
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

#add to path to run python commands in created virtual environment
ENV PATH="/py/bin:$PATH"

USER django-user