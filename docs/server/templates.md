# 部署範本

以下範例使用 Service ID `example`、Web Port `3000`，並包含 PostgreSQL。

實際使用前，請依專案調整 `build`、image、Port、volume 及環境變數，並將 `example` 替換為核准的 Service ID。

!!! warning "請勿設定 container_name"

    請保留由 Docker Compose 自動產生的 Container 名稱。

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
    image: postgres:17
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - default
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

對應的 `.env.example` 可寫為：

```dotenv
POSTGRES_DB=example
POSTGRES_USER=example
POSTGRES_PASSWORD=replace-with-a-random-password
```

正式環境的 `.env` 不得提交至 Repository。
