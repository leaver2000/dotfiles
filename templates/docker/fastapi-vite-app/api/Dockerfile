FROM python:3.10-slim-buster
WORKDIR /
# create a virtual environment and set the PATH
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
# prior to copying the application code, install the
# dependencies. This way, the requirements can be cached and only the
# application code needs to be copied again when it changes.
COPY requirements.txt .
RUN python -m pip install --no-cache-dir --requirement requirements.txt \
    && rm requirements.txt

COPY app/ app/
EXPOSE 80
ENTRYPOINT [ "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80" ]
