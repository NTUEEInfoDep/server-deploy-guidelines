# 台大電機系學會資訊部網站服務規範

本 Repository 使用 MkDocs 維護資訊部網站服務的申請、Domain 命名與 Docker Compose 部署規範。

## 本機預覽

```bash
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install -r requirements.txt
mkdocs serve
```

## 建置

```bash
mkdocs build --strict
```

網站內容位於 `docs/`，可複製的部署範本位於 `docs/server/templates.md`。

## Production

使用 `main` branch，以根目錄的 `docker-compose.yml` 部署。
Nginx Proxy Manager 須與本服務位於同一台 Docker Host，並加入同一個 external `nginx` network。在 NPM 新增 Proxy Host：

- Domain Names：`docs.ntueeinfodep.ntuee.org`
- Scheme：`http`
- Forward Hostname / IP：`ntueeinfodep-docs`
- Forward Port：`80`

SSL 頁籤設定此網域的憑證並啟用 Force SSL。Compose 的 network alias 不會自動建立 NPM Proxy Host。

首次部署（須已有 external `nginx` network）：

```bash
mkdir -p ~/productions
git clone --branch main https://github.com/NTUEEInfoDep/server-deploy-guidelines.git ~/productions/ntueeinfodep-docs
cd ~/productions/ntueeinfodep-docs
docker compose config
docker compose up -d --build
docker compose ps
```

更新（於部署目錄執行）：

```bash
git pull --ff-only origin main
docker compose up -d --build
```

部署後確認 <https://docs.ntueeinfodep.ntuee.org/> 可正常瀏覽。停止服務：

```bash
docker compose down
```
