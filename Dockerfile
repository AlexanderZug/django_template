FROM python:3.14.0rc3-slim-bookworm
WORKDIR /app
COPY uv.lock pyproject.toml /app/
ENV UV_PROJECT_ENVIRONMENT=/usr/local
RUN pip install --upgrade pip && pip install uv && uv sync --locked
COPY . /app
RUN chown -R 1000:1000 /app
EXPOSE 8000
RUN chmod +x app/runner/*.sh
ENTRYPOINT ./runner/django_run.sh
