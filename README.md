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

網站內容位於 `docs/`，提供給網站服務的可複製範本位於 `templates/`。
