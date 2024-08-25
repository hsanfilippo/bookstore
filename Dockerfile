FROM python:3.11-slim AS python-base

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    \

    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    \

    POETRY_VERSION=1.0.3 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    \

    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"

ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        curl \
        build-essential

RUN pip install poetry poetry init

RUN apt-get update \
    && apt-get -y install libpq-dev gcc \
    && pip install psycopg2

WORKDIR $PYSETUP_PATH

COPY poetry.lock pyproject.toml ./

RUN poetry install

WORKDIR /app

COPY . /app/

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]