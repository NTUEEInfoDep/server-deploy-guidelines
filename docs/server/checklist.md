# 部署檢查清單

提出申請前，請確認下列項目。

## Repository

- [ ] 已指定 Production branch。
- [ ] 已以可直接執行的指令提供初次部署、更新、停止服務及驗證方式。
- [ ] 部署說明保持精簡，未重述通用部署規範或 Compose 已清楚表達的設定。
- [ ] 已提供 Production 使用的 Dockerfile 與 Docker Compose 設定。
- [ ] Production 部署不需在 Host 直接執行 `pnpm`、`npm`、`pip` 等專案工具。

## Docker

- [ ] Application 由目前 Repository 建置，或使用可明確對應目前版本來源的 Image。
- [ ] Compose `name` 等於核准的 Service ID，且未設定 `container_name`。
- [ ] Web service 已加入 `nginx` network，alias 等於 Service ID。
- [ ] 未使用未核准的 Host Port mapping。
- [ ] 未使用未核准的 `privileged`、`network_mode: host` 或 Docker socket。

## 資料與初始化

- [ ] Database、uploads 等持久資料已設定 volume 或適當的 bind mount。
- [ ] Container 重建或移除後不會遺失必要資料。
- [ ] Migration、初始化及 seed 已納入 Docker 流程，不需在 Host 手動執行專案指令。

## 驗證

至少執行：

```bash
docker compose config
docker compose up -d --build
docker compose ps
```

並確認 Web service 可由 `nginx` network 透過 Service ID 與指定 Port 存取。
