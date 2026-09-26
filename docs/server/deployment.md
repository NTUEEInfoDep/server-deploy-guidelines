# 部署規範

本頁規定網站服務部署至資訊部伺服器時應遵守的基本要求。Docker Compose 的具體設定請參考 [Docker 部署規範](docker.md)。

如有本規範未涵蓋的特殊需求，應於申請時提出，並於部署前取得資訊部確認。

## Repository 與部署文件

Repository 應明確指定用於正式環境（Production）部署的 branch，並提供：

1. **部署說明文件**

   應以 SOP 形式列出初次部署、更新及停止服務所需的步驟與指令。

   可撰寫於根目錄 `README.md` 的 `Production` 或 `Deployment` 區段，或另行撰寫於 `production.md`，並由 `README.md` 明確連結。

2. **Production 使用的 Docker 設定**

   Repository 應包含 Production 使用的 `Dockerfile` 與 Docker Compose 設定。Compose 檔案原則上置於根目錄；如使用其他檔名或位置，應於部署說明中註明。

## Production 部署方式

Production 環境應透過 Docker 建置及執行。

除 Git、Docker 與 Docker Compose 等部署工具外，不得要求在 Host 安裝或直接執行專案使用的 Runtime、Package Manager 或 Build Tool，例如 `pnpm build`、`npm run build` 或 `pip install`。

依賴安裝、程式建置及執行環境應納入 Dockerfile 或 Container 內。

## 資料與初始化

Database、使用者上傳檔案及其他需持久保存的資料，必須使用適當的 persistent storage，確保 Container 重建或移除後資料仍可保留。

首次部署所需的 migration、schema initialization、seed 或其他初始化程序，必須納入版本控制並自動化，不得依賴未記錄的人工操作。

具體方式請參考 [Docker 部署規範](docker.md)。

## 部署與驗證

部署說明中的步驟應可由其他人依序執行，不應依賴未記載的環境或操作。

提出申請前，請依 [部署檢查清單](checklist.md) 完成檢查。若需資訊部協助部署，應另提供可確認服務正常運作的檢查方式。
