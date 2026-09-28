# Docker 部署規範

本頁規定部署至資訊部伺服器之 Docker 技術要求。

## Application 建置

自行開發的 Application service 原則上應由目前 Repository 內的 Dockerfile 建置：

```yaml
services:
  web:
    build: .
```

不得直接沿用舊專案留下、且無法確認與目前 Repository 內容一致的 Application Image。

如需使用預先建置的 Application Image，部署文件必須能明確對應其來源 Repository 與 commit、tag 或其他版本識別。Image tag 允許使用 `latest`；使用 `latest` 等可變 tag 時，部署後應記錄實際使用的 Image ID 或 digest，以便追查及回復。無法確認來源者不得使用。

PostgreSQL、Redis、Nginx 等第三方基礎服務可使用其官方 Image。Image tag 可指定明確版本，也允許使用 `latest`。

使用 `latest` 不視為違反規範，但應注意該 tag 指向的內容可能改變。執行 `docker compose pull` 或重新部署前，應先確認相容性、備份持久資料，並保留可回復至原 Image ID 或 digest 的資訊。

Production 部署不得要求在 Host 直接執行 `pnpm`、`npm`、`pip` 或其他專案 Runtime、Package Manager、Build Tool。相關步驟應在 Dockerfile 或 Container 內完成。

## Compose name 與 Container 名稱

Docker Compose 頂層必須設定 `name`，其值應等於資訊部核准的 Service ID：

```yaml
name: example
```

!!! danger "不得設定 container_name"

    各 service 不得設定 `container_name`。Container 名稱應由 Docker Compose 自動產生。

Service key 應使用可辨識用途的名稱，例如 `web`、`db`、`redis`。

## Nginx 反向代理

網站服務由資訊部統一透過 Nginx 對外提供 HTTP(S) 服務，一般服務不需自行設定 Nginx。

Web service 必須可由既有的 `nginx` Docker network，透過與 Service ID 相同的 alias 及指定 Container Port 存取。

如需特殊 Nginx 設定，應於申請時提出；可提供建議的 Nginx configuration，實際設定由資訊部確認。

## Docker Network

對外提供 HTTP 服務的 Web service 必須同時加入專案內部 network 與既有的 external `nginx` network。

Database、Redis 等不需由反向代理直接存取的內部 service 不得加入 `nginx` network。

Web service 應在 `nginx` network 上設定與 Service ID 相同的 alias：

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

Web service 應使用 `expose` 標示 Container 內提供 HTTP 服務的 Port：

```yaml
expose:
  - "3000"
```

並符合下列要求：

- 原則上不得使用 `ports` 將服務 Port 映射至 Host。
- Web server 必須監聽 `0.0.0.0:<port>`，不得僅監聽 Container 內的 `127.0.0.1`。
- 如確有 Host Port mapping 需求，應於申請時說明並取得核准。

## Persistent Storage

Container 應視為可重建。Database、使用者上傳檔案及其他需持久保存的資料，不得僅存放於 Container writable layer。

持久資料可使用 named volume 或 bind mount。雖不強制，強烈建議為 Database、使用者上傳檔案及其他需保存資料的 service，在 Repository 內規劃各自獨立的資料夾，並以相對路徑 bind mount 至 Container 的資料目錄。如此部署所需的資料位置會與專案放在一起，較容易辨識、備份與搬移。

以下以 PostgreSQL 18 官方 Image 為例，將 Host 上 Repository 內的 `data/postgres` 映射至 Container：

```yaml
services:
  db:
    image: postgres:18
    volumes:
      - ./data/postgres:/var/lib/postgresql
```

Repository 內的持久資料夾不得提交至 Git，應加入 `.gitignore`，例如：

```gitignore
/data/
```

若同一專案有多個需持久保存資料的 service，應使用不同子資料夾，例如 `data/postgres`、`data/redis` 與 `data/uploads`，不得共用同一資料目錄。

如使用 Repository 以外的 bind mount，Host 路徑應固定、用途明確並記載於部署說明，不得使用 `/tmp` 等暫存位置。若使用 named volume，仍應確認備份、還原及搬移方式。

Volume 或 bind mount 的 Container 路徑應符合所使用 Application 或官方 Image 的資料目錄。

## Initialization

首次部署所需的 migration、schema initialization、seed 或其他初始化程序必須納入 Repository，並由 Docker 部署流程執行。

可採用下列方式之一：

- Container 的 entrypoint 或啟動 script。
- Docker Compose 中的一次性 service。
- 第三方官方 Image 提供的初始化機制。

自行撰寫的初始化 script 應存放於 Repository，例如 `scripts/init.sh`，並由 Container 執行。

不得要求管理者在 Host 直接執行專案 Runtime 或 Package Manager 指令完成初始化。

## 重啟設定

需要持續運作的 service 應設定：

```yaml
restart: unless-stopped
```

服務使用期限請參考 [使用期限](application.md#expiry)。

## 環境變數與機密資料

- Repository 可提供 `.env.example`，列出必要變數及非機密範例值。
- 不得將密碼、API Token、私鑰或其他機密資料提交至 Repository。
- Production 使用的 `.env` 應只保留於伺服器，並加入 `.gitignore`。
- `.env.example` 應以註解簡短記載必要環境變數的用途；部署說明不需再次逐項解釋，且不得記載正式機密值。

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

如需其他 Host 權限、Host filesystem 或特殊網路設定，應於申請時說明。
