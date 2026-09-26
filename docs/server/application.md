# 網站服務申請與部署

本規範說明向臺大電機系學會資訊部申請 `ntuee.org` 子網域及部署網站於資訊部伺服器之流程。

符合下列任一情況者，請事先提出申請：

- 使用 `ntuee.org` 之 Domain。
- 將網站服務部署於資訊部管理之伺服器，不論使用何種 Domain。

[填寫網站服務申請表](https://forms.gle/v27p3Fip8TT9CtUL6){ .action-link }

## 相關文件

- [Domain 與 Service ID](naming.md)：Domain 命名與 Service ID 規則。
- [部署規範](deployment.md)：Production 部署應遵守的基本要求。
- [Docker 部署規範](docker.md)：Docker Compose、network、storage 及初始化等技術要求。
- [部署檢查清單](checklist.md)：提出申請前的簡要檢查項目。

## 申請流程

1. 準備開發完成的 GitHub Repository，並指定 Production 使用的 branch。
2. 依 [部署規範](deployment.md) 與 [Docker 部署規範](docker.md) 準備 Production 部署設定及部署說明文件。
3. [填寫網站服務申請表](https://forms.gle/v27p3Fip8TT9CtUL6)，提出希望使用的 Domain、預計下線日期及特殊需求。
4. 資訊部確認 Domain、Service ID 與部署設定。
5. 經確認後，由申請單位自行部署，或由資訊部協助部署。若需資訊部協助，請提供可確認部署成功的檢查方式。
6. 服務部署完成且可正常存取後，由資訊部完成 DNS 與對外連線設定。

## 特殊需求

如需 Host Port、特殊 network 或權限、非標準部署方式，應於申請時說明。

如需自訂 Header、Path routing、WebSocket 或其他特殊 Nginx 行為，亦應於申請時提出；可一併提供建議的 Nginx configuration，實際設定由資訊部確認。

## 使用期限 { #expiry }

申請人應於申請時填寫服務之預計下線日期。

服務超過預計下線日期後，資訊部不保證其持續運作。若服務因伺服器重啟、系統維護、故障或其他原因停止，資訊部得不予重新啟動，並得移除相關 DNS 與反向代理設定。

如需繼續使用，應於到期前提出展延申請。
