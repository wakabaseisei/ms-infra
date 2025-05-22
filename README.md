# ms-infra

このリポジトリは、MSプロジェクトにおける **AWSインフラ全体をTerraformで構築・管理** するためのリポジトリです。  
本番・開発環境ともに一貫したコードベースで、再現性とセキュリティ、運用効率を実現しています。

## 📎 インフラ構成図

![Image](https://github.com/user-attachments/assets/eb7e36c9-35f8-40d2-867f-6fb063f682f8)


---

## 📁 ディレクトリ構成
```
.
├── modules/ # 再利用可能なTerraformモジュール群
│ ├── application/
│ ├── container-orchestration/
│ ├── database/
│ ├── database-user-generator/
│ ├── gateway/
│ ├── network/
│ ├── tf-pipeline/
│ └── web-hosting/
├── platform/ # AWS Organizations（OU・アカウント管理）
├── services/ # 環境ごとのサービス構成
│ ├── api-front/dev/
│ ├── ms-user/dev/
│ ├── ms-web/dev/
│ └── platform/dev/ # 共通基盤（VPC、EKSなど）の構成
└── README.md
```

---

## 🛠 使用技術

| 分類 | 技術 | 補足 |
|------|------|------|
| IaC | Terraform | モジュール分割で再利用性と責務分離を実現 |
| CI/CD | GitHub Actions, terraform-docs | Plan/ApplyのIAM Role分離、Terraformドキュメント自動生成対応 |
| コンテナ基盤 | EKS, IRSA, OIDC | IRSAによるPod単位のIAM制御、GitHub Actions連携 |
| ネットワーク | VPC, Public/Private/DB Subnet, NAT Gateway, IGW, VPC Endpoint（ECR/S3） | セキュアな分離構成とインターフェース型/ゲートウェイ型VPCE活用 |
| セキュリティ | IAM, KMS（Secrets暗号化）, OIDC Provider | EKS/CI用IAMロール、KMSによるEKS Secretsの暗号化設定 |
| データベース | Aurora MySQL Serverless v2, Secrets Manager, Lambda | IAM認証＋Lambdaによるユーザー作成、Migration Lambda構成あり |
| デプロイ/運用 | ArgoCD（Helmリリース）, ECR | GitOpsによる自動反映、コンテナビルド〜デプロイまで連携 |
| 配信構成 | ALB（Private）, CloudFront（VPCオリジン/OAC）, S3 | SPA配信 + 内部APIルーティングを考慮したCloudFront構成 |

---

## 📄 備考

- `platform/` ディレクトリでは AWS Organizations を用いたマルチアカウント管理をコード化
- `services/platform/` 配下では、VPCやEKSなどの**環境内共通基盤**を構築
- Terraformのモジュールは明確に分割され、サービスごとの責務も定義済み
- GitHub Actionsからの `AssumeRoleWithWebIdentity` による Plan/Apply 分離やドキュメント生成まで自動化済み

