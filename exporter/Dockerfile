FROM python:3.12-slim
RUN groupadd -r exporter && useradd -r -g exporter exporter
WORKDIR /app
COPY exporter/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY exporter/sxt_exporter.py exporter/economics.py ./
COPY scripts/ ./scripts/
USER exporter
EXPOSE 9101
ENTRYPOINT ["python", "-u", "sxt_exporter.py"]
