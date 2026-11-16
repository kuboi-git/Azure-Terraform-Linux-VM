# Azure-Terraform-Linux-VM

# 1. 概要

Terraformを使い、AzureのJapan EastリージョンにUbuntu 22.04 LTSの仮想マシンとネットワークを構築しました。
SSHのパスワード認証を無効にし、公開鍵認証でVMに接続しました。VM上でnginxをインストールし、VM内でHTTP 200が返ることと、PCのブラウザからパブリックIP経由で「Welcome to nginx!」が表示されることを確認しました。 

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
1. **SSH鍵を作成**  
   Windowsで鍵のペアを作成し、公開鍵を `main.tf` に設定しました。
   
3. **Terraformを初期化**  
   `terraform init` を実行し、AzureRMプロバイダーを準備しました。

4. **作成予定を確認**  
   `terraform plan` を実行し、10件の新規作成、変更・削除は0件であることを確認しました。

5. **Azure環境を構築**  
   `terraform apply` を実行し、VMとネットワークを構築しました。NSGのサブネットへの関連付けと、SSH（TCP 22）・HTTP（TCP 80）の受信ルールもこの段階で作成しました。

6. **VMにSSH接続**  
   VMのパブリックIPを確認し、Windowsに保存した秘密鍵を指定して接続しました。

7. **nginxをインストール**  
   SSH接続したUbuntu上で `sudo apt update` と `sudo apt install nginx` を実行しました。

---

# 5. 動作確認

### SSH接続確認

WindowsのPowerShellから、秘密鍵を指定してUbuntu VMに接続しました。

```bash
ssh -i "<秘密鍵のパス>" azureuser@<VMのパブリックIP>
```


#### nginx動作確認
**VM内**：`curl -I http://localhost` を実行し、`HTTP/1.1 200 OK` と `Server: nginx/1.18.0 (Ubuntu)` を確認しました。

<img width="387" height="29" alt="スクリーンショット 2026-11-16 233834" src="https://github.com/user-attachments/assets/89eb8a40-2a8f-4afa-bd78-03434133d4b6" />

**PCのブラウザ**：`http://<VMのパブリックIP>` を開き、「Welcome to nginx!」が表示されることを確認しました。
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
