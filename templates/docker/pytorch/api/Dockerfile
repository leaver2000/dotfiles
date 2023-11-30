FROM nvidia/cuda:12.1.0-base-ubuntu22.04
USER root
WORKDIR /
# The nvidia/cuda image does not have python3 installed
# so we need to install it manually
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        python3=3.10.6-1~22.04 \
        python3-venv=3.10.6-1~22.04 \
    && rm -rf /var/lib/apt/lists/*
# create a virtual environment and set the PATH
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
# prior to copying the application code, install the
# dependencies. This way, the requirements can be cached and only the
# application code needs to be copied again when it changes.
COPY requirements.txt .
RUN python -m pip install --no-cache-dir --requirement requirements.txt \
    && rm requirements.txt

COPY app/ app/
EXPOSE 80

USER daemon
ENTRYPOINT [ "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80" ]
