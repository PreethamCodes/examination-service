FROM python:3.12-alpine
WORKDIR /probe
COPY config/health.txt .
USER nobody
ENV PORT=3002
CMD ["sh","-c","exec python -m http.server \"$PORT\" --bind 0.0.0.0 --directory /probe"]
