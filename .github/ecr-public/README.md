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

Push creates repos too, but pre-creating with catalog data gives a better gallery listing.

## 3. IAM user for GitHub Actions

Create IAM user `github-derrick-ecr-publish` with this policy:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr-public:GetAuthorizationToken",
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
    },
    {
      "Effect": "Allow",
      "Action": "sts:GetServiceBearerToken",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "sts:AWSServiceName": "ecr-public.amazonaws.com"
        }
      }
    }
  ]
}
```

## 4. GitHub repository secrets

Add to `nomatronio/derrick` → Settings → Secrets → Actions:

| Secret | Value |
|--------|-------|
| `AWS_ACCESS_KEY_ID` | IAM access key |
| `AWS_SECRET_ACCESS_KEY` | IAM secret key |

CI uses region `us-east-1` in the workflow. ECR publish is skipped until `AWS_ACCESS_KEY_ID` is set.

## 5. Verify manually

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
