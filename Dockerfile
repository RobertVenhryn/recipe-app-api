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
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

#add to path to run python commands in created virtual environment
ENV PATH="/py/bin:$PATH"

USER django-user