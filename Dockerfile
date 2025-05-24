FROM python:3.12.1-slim AS python-base

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"

ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# Instala dependências de sistema
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    curl \
    build-essential \
    libpq-dev \
    gcc

# Instala poetry e psycopg2
RUN pip install poetry psycopg2

# Instala as dependências Python
WORKDIR $PYSETUP_PATH
COPY poetry.lock pyproject.toml README.md ./
RUN poetry install --only main --no-root

# Copia código do app
WORKDIR /app
COPY . /app/

EXPOSE 8000

# Roda o servidor com o ambiente virtual criado pelo poetry
CMD ["poetry", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
