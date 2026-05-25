# Azure-Terraform-Linux-VM
# 1. 概要
Terraformを使用してAzure上にLinux VMを構築し、nginx Webサーバを公開しました。

Terraformにより以下リソースをコード管理しています。

---

# 2. 構成図

```text
Resource Group
rg-terraform-test
│
├─ Virtual Network
│    vnet-terraform-test
│    10.0.0.0/16
│
│    └─ Subnet
│         subnet-terraform-test
│         10.0.10.0/24
│
│         └─ Network Security Group
│              nsg-terraform-test
│              ├─ Allow SSH (22)
│              └─ Allow HTTP (80)
│
├─ Public IP
│    pip-terraform-test
│    Static IP
│
├─ Network Interface
│    nic-terraform-test
│    ├─ Connected Subnet
│    │    subnet-terraform-test
│    └─ Connected Public IP
│         pip-terraform-test
│
└─ Linux Virtual Machine
     vm-terraform-test
     Ubuntu 22.04
     Size: Standard_D2s_v3
     │
     └─ nginx
          Web Server
          │
          └─ Welcome to nginx!
```
---

# 3. 使用サービス
| Service                      | Purpose    |
| ---------------------------- | ---------- |
| Azure Resource Group         | リソース管理     |
| Azure Virtual Network        | 仮想ネットワーク作成 |
| Azure Subnet                 | サブネット作成    |
| Azure Network Security Group | 通信制御       |
| Azure Public IP              | 外部公開IP     |
| Azure Network Interface      | VMネットワーク接続 |
| Azure Linux Virtual Machine  | Linuxサーバ構築 |
| nginx                        | Webサーバ     |
| Terraform                    | IaC構成管理    |

---

# 4. 作成順序
1. Resource Group 作成
2. Virtual Network 作成
3. Subnet 作成
4. Network Security Group 作成
5. NSG を Subnet に関連付け
6. Public IP 作成
7. Network Interface 作成
8. Linux VM 作成
9. SSH接続確認
10. nginx インストール
11. HTTP(80)許可
12. ブラウザ表示確認

---

# 5. 動作確認

### SSH接続確認

Linux VMへのSSH接続成功を確保。

```bash
ssh azureuser@PublicIP
```

#### nginx動作確認
ブラウザで下記でアクセス

```bash
http://PublicIP
```
<img width="666" height="233" alt="welcome" src="https://github.com/user-attachments/assets/37ab5fd2-b1a3-427d-acda-348a8fb84a4e" />

---

# 6. 苦労したこと
## VMサイズ不足エラー

### 原因
Japan East で利用可能なVMサイズ不足。

### 解決方法
VMサイズを Standard_D2s_v3 に変更し解決。

---

## SSH接続タイムアウト

### 原因
NSGで22番ポート許可が未設定。

### 解決方法
NSGへSSH許可ルールを追加し解決。

---

## nginxへアクセス不可

### 原因
HTTP(80番)がNSGで未許可。

### 解決方法
HTTP許可ルール追加で解決。

---

# 7. 学んだこと
- Terraform による Azure インフラ構築
- Azure VM 作成時のネットワーク構成
- NSG による通信制御
- Public IP と NIC の役割
- SSH接続の仕組み
- nginx によるWebサーバ公開
- Terraform のエラー修正方法
