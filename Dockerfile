FROM python:3.14.1-slim
WORKDIR /app/
COPY uv.lock pyproject.toml /app/
RUN pip install --upgrade pip \
    && pip install uv \
    && uv install --no-interaction --no-ansi
COPY . /app
RUN chown -R 1000:1000 /app
EXPOSE 8000
RUN chmod +x app/runner/*.sh
ENTRYPOINT ./runner/django_run.sh
