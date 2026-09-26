# 部署規範

本頁規定網站服務部署至資訊部伺服器時應遵守的最低要求。

如有本規範未涵蓋的特殊需求，應於申請時提出，並於部署前取得資訊部確認。

## Repository 與部署文件

Repository 應明確指定用於正式環境（Production）部署的 branch，並提供下列文件：

1. **部署說明文件**

   部署說明應採 SOP 形式撰寫，清楚列出部署、更新及停止服務所需的步驟與指令，避免加入與部署無關的內容。

   接受下列任一形式：

   - 撰寫於 Repository 根目錄 `README.md` 的 `Production` 或 `Deployment` 區段。
   - 另行撰寫於 `production.md`，並於根目錄 `README.md` 明確標示文件位置。

2. **Production 使用的 Docker Compose 設定**

   原則上使用 Repository 根目錄的 `docker-compose.yml` 或 `docker-compose.prod.yml`。

   如使用其他檔名或位置，應於部署說明文件中明確註明實際部署指令。

## Compose name 與 Container 名稱

Docker Compose 頂層必須設定 `name`，其值應等於資訊部核准的 Service ID：

```yaml
name: example
```

!!! danger "不得設定 container_name"

    各 service 不得設定 `container_name`。Container 名稱由 Docker Compose 自動產生。

Service key 應使用可辨識用途的名稱，例如 `web`、`db`、`redis`。

## Nginx 反向代理

網站服務由資訊部統一透過 Nginx 對外提供 HTTP(S) 服務。

一般服務僅需依下列 Docker Network 與 Port 規範部署，不需自行設定 Nginx。

如服務需要特殊的 Nginx 設定，例如自訂 Header、Path routing、WebSocket 或其他 Proxy 行為，應於申請時說明。必要時可一併提供建議的 Nginx configuration，實際設定由資訊部確認。

## Docker Network

對外提供 HTTP 服務的 Web service 必須同時加入：

- 專案內部 network。
- 既有的 external `nginx` network。

Database、Redis 等內部 service 不得加入 `nginx` network。

Web service 必須在 `nginx` network 上設定與 Service ID 相同的 alias：

```yaml
services:
  web:
    networks:
      default:
      nginx:
        aliases:
          - example

networks:
  nginx:
    external: true
```

## Port 與監聽位址

Web service 應使用 `expose` 標示 Container 內提供服務的 Port：

```yaml
expose:
  - "3000"
```

並符合下列要求：

- 原則上不得使用 `ports` 將服務 Port 映射至 Host。
- Web server 必須監聽 `0.0.0.0:<port>`，不得僅監聽 `127.0.0.1`。
- 如確有 Host Port mapping 需求，應於申請時說明並取得核准。

## 重啟設定

需要持續運作的 service 應設定：

```yaml
restart: unless-stopped
```

服務超過核准使用期限後，資訊部不再保證其持續運作或於停止後重新啟動。詳情請參考 [使用期限](application.md#expiry)。

## 禁止設定

除非事先取得資訊部核准，不得使用：

```yaml
privileged: true
network_mode: host
```

亦不得掛載 Docker socket：

```text
/var/run/docker.sock
```

如需其他 Host 權限、Host filesystem 或特殊網路設定，應於部署前提出說明。

## 環境變數與機密資料

- Repository 可提供 `.env.example`，列出必要變數及非機密範例值。
- 不得將密碼、API Token、私鑰或其他機密資料提交至 Repository。
- Production 使用的 `.env` 應只保留於伺服器，並加入 `.gitignore`。
- 部署說明文件應說明必要環境變數及其用途，不得記載正式機密值。

## 部署檢查

部署前先執行：

```bash
docker compose config
```

確認無誤後依部署說明進行部署。部署完成後至少確認：

```bash
docker compose ps
```

並確認：

- Compose project 名稱與核准的 Service ID 相同。
- Compose 設定未使用 `container_name`。
- Web service 已加入 `nginx` network 並設定正確 alias。
- 未設定未經核准的 Host Port mapping。
- Web service 可透過指定 alias 與 Port 存取。
