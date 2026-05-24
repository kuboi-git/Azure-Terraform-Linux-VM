# Azure-Terraform-Linux-VM

# Azure Terraform Linux VM

# 1. 概要
Terraform を使用して Azure 上に Linux VM を構築し、
nginx Web サーバを公開しました。

Terraform により以下リソースをコード管理しています。

- Resource Group
- Virtual Network
- Subnet
- Network Security Group
- Public IP
- Network Interface
- Linux Virtual Machine

また、SSH接続および nginx の動作確認を実施しました。

---

# 2. 構成図
```text
Internet
   ↓
Public IP
   ↓
Network Security Group
   ↓
Network Interface
   ↓
Linux Virtual Machine
   ↓
nginx
3. 使用サービス
Service	Purpose
Azure Resource Group	リソース管理
Azure Virtual Network	仮想ネットワーク作成
Azure Subnet	サブネット作成
Azure Network Security Group	通信制御
Azure Public IP	外部公開IP
Azure Network Interface	VMネットワーク接続
Azure Linux Virtual Machine	Linuxサーバ構築
nginx	Webサーバ
Terraform	IaC構成管理
4. 作成順序
Resource Group 作成
Virtual Network 作成
Subnet 作成
Network Security Group 作成
NSG を Subnet に関連付け
Public IP 作成
Network Interface 作成
Linux VM 作成
SSH接続確認
nginx インストール
HTTP(80)許可
ブラウザ表示確認
5. 動作確認
SSH接続確認
ssh azureuser@PublicIP

Linux VM へのSSH接続成功を確認。

nginx動作確認

ブラウザで下記へアクセス。

http://PublicIP

「Welcome to nginx!」表示を確認。

6. 苦戦したこと
VMサイズ不足エラー
Cause

Japan East で利用可能なVMサイズ不足。

Resolution

VMサイズを Standard_D2s_v3 に変更し解決。

SSH接続タイムアウト
Cause

NSGで22番ポート許可が未設定。

Resolution

NSGへSSH許可ルールを追加し解決。

nginxへアクセス不可
Cause

HTTP(80番)がNSGで未許可。

Resolution

HTTP許可ルール追加で解決。

7. 学んだこと
Terraform による Azure インフラ構築
Azure VM 作成時のネットワーク構成
NSG による通信制御
Public IP と NIC の役割
SSH接続の仕組み
nginx によるWebサーバ公開
Terraform のエラー修正方法
