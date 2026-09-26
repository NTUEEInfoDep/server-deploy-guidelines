# 網站服務申請與部署

本規範說明向臺大電機系學會資訊部申請 `ntuee.org` 子網域及部署網站於資訊部伺服器之流程。

符合下列任一情況者，請事先提出申請：

- 使用 `ntuee.org` 之 Domain。
- 將網站服務部署於資訊部管理之伺服器，不論使用何種 Domain。

[填寫網站服務申請表](#application-form){ .action-link }

## 相關文件

- [Domain 與 Service ID](naming.md)：Domain 命名原則及 Service ID 轉換規則。
- [部署規範](deployment.md)：Repository、Docker Compose、network、Port 及環境變數等部署要求。
- [部署範本](templates.md)：可直接修改使用之 `docker-compose.yml` 範例。

## 申請流程

1. 準備開發完成的 GitHub Repository。
2. 依 [部署規範](deployment.md) 準備 Production 使用的 `Dockerfile`、`docker-compose.yml` 及部署說明文件。
3. 填寫[網站服務申請表](#application-form)。
4. 資訊部確認 Domain、Service ID 與部署設定。
5. 經確認後，由申請單位自行部署，或由資訊部協助部署。若需資訊部協助，請提供可確認部署成功的檢查方式。
6. 資訊部完成 DNS 與對外連線設定後，網站正式上線。

## 部署要求

部署前應確認下列事項：

- 未經資訊部確認，不得自行認定 Domain 已核准或可供使用。
- Repository 根目錄應包含 `README.md` 及 Production 使用的 Docker Compose 設定。
- 服務應部署於 `~/productions/<service_id>/`。
- Docker Compose 不應設定 `container_name`。
- Web service 應透過既有的 `nginx` Docker network 提供服務，原則上不得將服務 Port 映射至 Host。
- 部署說明文件應包含可直接執行的部署、更新及停止服務步驟。

部署前請先閱讀 [Domain 與 Service ID](naming.md)，並依 [部署規範](deployment.md) 及 [部署範本](templates.md) 準備服務。

## 使用期限 { #expiry }

申請人應於申請時填寫服務之預計下線日期。

服務超過預計下線日期後，資訊部不保證其持續運作。若服務因伺服器重啟、系統維護、故障或其他原因停止，資訊部得不予重新啟動，並得移除相關 DNS 與反向代理設定。

如需繼續使用，應於到期前提出展延申請。
