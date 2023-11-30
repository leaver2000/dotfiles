
FROM python:3.10.11-slim
WORKDIR /
USER root

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY api/ api/

EXPOSE 80
USER 1001
CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "80"]
