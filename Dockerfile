FROM python:3.9-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.9-slim
WORKDIR /app
RUN addgroup --system devopsgroup && adduser --system --ingroup devopsgroup devopsuser
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY . .
RUN chown -R devopsuser:devopsgroup /app
USER devopsuser
EXPOSE 5000
CMD ["python", "app.py"]
