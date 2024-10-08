FROM python:3.9-slim
LABEL maintainer="akshayrathod10"

ENV PYTHONUNBUFFERED=1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apt-get update && \
    apt-get -y install libpq-dev gcc && \
    /py/bin/pip install psycopg2 && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    /py/bin/pip install flake8 && \
    if [ "$DEV" = "true" ]; then \
        /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser --disabled-password --no-create-home django-user && \
    chown -R django-user:django-user /app /py

ENV PATH="/py/bin:$PATH"

USER django-user
