# 部署範本

以下為單一 Web service 搭配 PostgreSQL 的最小範例。範例使用 Service ID `example` 與 Web Container Port `3000`。

實際使用前，請依專案調整環境變數、Port 與資料目錄，並將 `example` 替換為核准的 Service ID。

## README Production 區塊範本

README 的 Production 區塊應以可執行的指令為主。以下為最小範本；沒有環境變數時，刪除複製及編輯 `.env` 的指令。

````markdown
## Production

使用 `main` branch，以根目錄的 `docker-compose.yml` 部署。

首次部署：

```bash
git clone --branch main <repository-url> ~/productions/example
cd ~/productions/example
cp .env.example .env
vim .env
docker compose up -d --build
docker compose ps
```

更新：

```bash
git pull --ff-only origin main
docker compose up -d --build
docker compose ps
```

部署後確認 `<health-check-url>` 可正常存取。停止服務：

```bash
docker compose down
```
````

如有專案特有且無法自動化的必要操作，僅補充對應指令。較長的 migration 或版本切換流程應另建文件，並在此區塊提供連結。

## Docker Compose 範本

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
      - ./data/postgres:/var/lib/postgresql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $$POSTGRES_USER -d $$POSTGRES_DB"]
      interval: 10s
      timeout: 5s
      retries: 5

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

範例採用建議的 bind mount，將 PostgreSQL 資料保存在 Host 上 Repository 內的 `data/postgres`。此做法並非強制；如改用 named volume，仍須確保資料可備份、還原及搬移。`data/` 必須加入 `.gitignore`，不得將正式資料提交至 Git。

如專案需要 migration 或其他初始化程序，請依 [Docker 部署規範](docker.md#initialization) 納入 Docker 部署流程。
