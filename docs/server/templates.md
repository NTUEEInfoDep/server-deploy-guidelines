# 部署範本

以下為單一 Web service 搭配 PostgreSQL 的最小範例。範例使用 Service ID `example` 與 Web Container Port `3000`。

實際使用前，請依專案調整環境變數、Port 與資料目錄，並將 `example` 替換為核准的 Service ID。

```yaml
name: example

services:
  web:
    build: .
    restart: unless-stopped
    environment:
      DATABASE_URL: postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@db:5432/${POSTGRES_DB}
    expose:
      - "3000"
    networks:
      default:
      nginx:
        aliases:
          - example
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres:18
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - db-data:/var/lib/postgresql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $$POSTGRES_USER -d $$POSTGRES_DB"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  db-data:

networks:
  nginx:
    external: true
```

對應的 `.env.example`：

```dotenv
POSTGRES_DB=example
POSTGRES_USER=example
POSTGRES_PASSWORD=replace-with-a-random-password
```

正式環境的 `.env` 不得提交至 Repository。

如專案需要 migration 或其他初始化程序，請依 [Docker 部署規範](docker.md#initialization) 納入 Docker 部署流程。
