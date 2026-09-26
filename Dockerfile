FROM python:3.12-alpine AS builder

WORKDIR /build
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY mkdocs.yml ./
COPY docs/ ./docs/
RUN mkdocs build --strict

FROM nginx:1.28-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /build/site/ /usr/share/nginx/html/

EXPOSE 80
