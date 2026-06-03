# Azure-Terraform-Linux-VM

# 1. 概要
Terraformを使用してAzure上にLinux VMを構築し、nginx Webサーバを公開しました。
また、SSH Key Authenticationによる安全なLinux VMへの接続を実装しました。 

Terraformにより以下リソースをコード管理しています。 
- Resource Group
- Virtual Network
- Subnet
- Network Security Group
- Public IP
- Network Interface
- Linux Virtual Machine

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
| SSH Key Authentication       | 安全なLinuxログイン |
| nginx                        | Webサーバ     |
| Terraform                    | IaC構成管理    |

---

# 4. 作成順序
1. Resource Group作成
2. Virtual Network作成
3. Subnet作成
4. Network Security Group作成
5. NSG を Subnetに関連付け
6. Public IP作成
7. Network Interface作成
8. Linux VM作成
9. SSH Key Authentication設定
10. SSH鍵認証接続確認
11. nginxインストール
12. HTTP(80)許可
13. ブラウザ表示確認

---

# 5. 動作確認

### SSH接続確認

SSH Key Authenticationを使用してLinux VMへの接続成功を確認。

```bash
ssh azureuser@PublicIP
```

#### nginx動作確認
ブラウザで下記URLへアクセス

```bash
http://PublicIP
```
<img width="666" height="233" alt="welcome" src="https://github.com/user-attachments/assets/37ab5fd2-b1a3-427d-acda-348a8fb84a4e" />

---

# 6. 苦労したこと
### VMサイズ不足エラー

#### 原因
Japan Eastリージョンで選択したVMサイズが利用できなかった。

#### 解決方法
VMサイズをStandard_D2s_v3に変更し解決。

---

### SSH鍵認証設定

#### 原因
公開鍵と秘密鍵の役割、およびTerraformへの設定方法の理解に苦戦した。

#### 解決方法
公開鍵をTerraformへ設定し、秘密鍵をローカルPCへ保存することで
SSH Key Authenticationによる安全なVM接続を実現した。
   
---

### nginxへアクセス不可

#### 原因
HTTP(80番)がNSGで未許可。

#### 解決方法
HTTP許可ルール追加で解決。

---

# 7. 学んだこと
- TerraformによるAzureインフラ構築
- Azure VM作成時のネットワーク構成
- NSGによる通信制御
- Public IPとNICの役割
- SSH接続の仕組み
- SSH Key Authenticationの仕組み
- Password認証とSSH鍵認証の違い
- 公開鍵と秘密鍵の役割
- nginxによるWebサーバ公開
- Terraformのエラー修正方法
