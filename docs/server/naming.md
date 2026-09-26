# Domain 與 Service ID

每個部署以一個主要 Domain 識別，並由主要 Domain 產生在伺服器上使用的 Service ID。

## Domain 命名

Domain 原則上使用小寫英文字母與數字，名稱應簡短並能辨識用途。最終名稱由資訊部確認後建立。

### 週期性活動

週期性活動使用「活動名稱加年份」作為 basename：

```text
camp2027.ntuee.org
```

活動 basename 應與歷年命名一致。若同一活動需要多個網站，可增加一層 subdomain：

```text
monopoly.camp2027.ntuee.org
```

### 跨年份服務

跨年份共用的活動網站不加入年份：

```text
make.ntuee.org
```

### 一般服務

一般服務使用簡短且可辨識用途的名稱：

```text
course.ntuee.org
```

## Service ID 轉換規則

Service ID 必須在整台伺服器上唯一，產生方式如下：

1. 移除 Domain 結尾的 `.ntuee.org`。
2. 將剩餘的 Domain 層級反向排列。
3. 以 `-` 連接各層級。

例如：

```text
camp2027.ntuee.org             → camp2027
monopoly.camp2027.ntuee.org      → camp2027-monopoly
course.ntuee.org               → course
docs.infodep.ntuee.org    → infodep-docs
```

如發生命名衝突，或服務使用非 `ntuee.org` Domain，由資訊部於核准時另行指定 Service ID。

## Service ID 使用位置

核准後，申請人應將相同 Service ID 用於：

- 部署目錄：`~/productions/<service_id>/`
- Docker Compose 頂層的 `name`
- Web service 在 `nginx` network 上的 alias

範例請參考 [部署範本](templates.md)。
