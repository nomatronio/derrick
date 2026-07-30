# AWS ECR Public setup for Derrick

Derrick publishes two public images to ECR Public:

| Repository | Pull URI |
|------------|----------|
| Server | `public.ecr.aws/nomatronio/derrick:<tag>` |
| ODR | `public.ecr.aws/nomatronio/derrick-odr:<tag>` |

Gallery URLs (after alias `nomatronio` is approved):

- https://gallery.ecr.aws/nomatronio/derrick
- https://gallery.ecr.aws/nomatronio/derrick-odr

## 1. Create public registry alias

ECR Public API calls use **`us-east-1`**.

1. Open [ECR Console](https://console.aws.amazon.com/ecr/) → region **US East (N. Virginia)**
2. Create the first public repository (step 2 below) — this creates your public registry
3. Go to **Registries** → select your public registry → **Edit**
4. Request **custom alias**: `nomatronio`
5. Set **display name**: `Nomatron Derrick`

Alias requests are reviewed by AWS. Pick carefully — aliases are difficult to change later.

## 2. Create repositories

Using AWS CLI (after `aws configure`):

```bash
export AWS_REGION=us-east-1

aws ecr-public create-repository \
  --repository-name derrick \
  --catalog-data file://.github/ecr-public/derrick-catalog.json \
  --region us-east-1

aws ecr-public create-repository \
  --repository-name derrick-odr \
  --catalog-data file://.github/ecr-public/derrick-odr-catalog.json \
  --region us-east-1
```

Or use the ECR console: **Create repository** → **Public** → name `derrick` / `derrick-odr`.

ECR Public **does not** auto-create repositories on `docker push` (unlike Docker Hub).
Repositories must exist before the first push. CI runs `ensure_ecr_public_repos.sh`
to create them if missing.

**Custom alias vs registry ID:** Repositories live under your account registry
(`748754852565`, etc.). CI resolves the push URI from `repositoryUri` returned by
AWS. If custom alias `nomatronio` is still pending approval, AWS may only expose
`public.ecr.aws/<default-alias>/derrick` until the custom alias activates — the
publish script follows whatever URI AWS returns.

Check your active URI:

```bash
aws ecr-public describe-repositories \
  --repository-names derrick derrick-odr \
  --region us-east-1 \
  --query 'repositories[].repositoryUri'
```

## 3. IAM user for GitHub Actions

Create IAM user `github-deployer` (or dedicated `github-derrick-ecr-publish`) with **one** of:

### Option A (recommended): AWS managed policy

Attach **`AmazonElasticContainerRegistryPublicFullAccess`** directly to the user.

This managed policy includes both required actions in one statement:
`ecr-public:*` and `sts:GetServiceBearerToken`.

### Option B: Inline/custom policy

If you prefer least-privilege custom policy, use this (note: **no Condition**
on `sts:GetServiceBearerToken` — match the AWS managed policy shape):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ECRPublicLogin",
      "Effect": "Allow",
      "Action": [
        "ecr-public:GetAuthorizationToken",
        "sts:GetServiceBearerToken"
      ],
      "Resource": "*"
    },
    {
      "Sid": "ECRPublicPush",
      "Effect": "Allow",
      "Action": [
        "ecr-public:BatchCheckLayerAvailability",
        "ecr-public:InitiateLayerUpload",
        "ecr-public:UploadLayerPart",
        "ecr-public:CompleteLayerUpload",
        "ecr-public:PutImage",
        "ecr-public:BatchGetImage",
        "ecr-public:DescribeRepositories",
        "ecr-public:CreateRepository"
      ],
      "Resource": "*"
    }
  ]
}
```

**Common mistake:** allowing `ecr-public:*` but omitting `sts:GetServiceBearerToken`.
Both are required for `aws ecr-public get-login-password`.

## 4. GitHub repository secrets

Add to `nomatronio/derrick` → Settings → Secrets → Actions:

| Secret | Value |
|--------|-------|
| `AWS_ACCESS_KEY_ID` | IAM access key |
| `AWS_SECRET_ACCESS_KEY` | IAM secret key |

CI uses region `us-east-1` in the workflow.

## 5. Troubleshooting ECR login in CI

If CI fails with:

```text
not authorized to perform: sts:GetServiceBearerToken
```

check these in order:

1. **Secrets match the IAM user** — In IAM → Users → `github-deployer` → Security credentials,
   confirm the active access key ID equals GitHub secret `AWS_ACCESS_KEY_ID`.
   If you rotated keys, update both GitHub secrets.

2. **Policy is attached to the user** — Not only edited/saved as a standalone customer-managed
   policy. Under Permissions, you should see either
   `AmazonElasticContainerRegistryPublicFullAccess` or an inline policy containing
   `sts:GetServiceBearerToken`.

3. **No permissions boundary blocking STS** — User → Permissions boundary. If set, the boundary
   must also allow `sts:GetServiceBearerToken`.

4. **Simulate the permission** (AWS CLI as an admin):

   ```bash
   aws iam simulate-principal-policy \
     --policy-source-arn arn:aws:iam::748754852565:user/github-deployer \
     --action-names sts:GetServiceBearerToken ecr-public:GetAuthorizationToken \
     --resource-arns "*"
   ```

   Both actions should return `"EvalDecision": "allowed"`.

5. **Test with the same keys CI uses**:

   ```bash
   export AWS_ACCESS_KEY_ID=...      # from GitHub secret
   export AWS_SECRET_ACCESS_KEY=...
   aws sts get-caller-identity       # should show github-deployer
   aws ecr-public get-login-password --region us-east-1
   ```

## 6. Verify manually

```bash
aws ecr-public get-login-password --region us-east-1 \
  | docker login --username AWS --password-stdin public.ecr.aws

docker pull hello-world
docker tag hello-world public.ecr.aws/nomatronio/derrick:test
docker push public.ecr.aws/nomatronio/derrick:test
```

After CI publishes a release:

```bash
docker pull public.ecr.aws/nomatronio/derrick:latest
docker pull public.ecr.aws/nomatronio/derrick-odr:latest
```

## Cost

ECR Public always-free tier: 50 GB storage, 500 GB/month anonymous pulls, 5 TB/month authenticated pulls. Sufficient for Derrick release images.
