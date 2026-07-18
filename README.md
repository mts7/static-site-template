# static-site-template

Static website template using Next.js (static export), CloudFront, S3, and Terraform. Each route
is pre-rendered HTML with per-page metadata, Open Graph/Twitter Card tags, and a sitemap/robots.txt
generated from the routes in `src/app`.

## Requirements

- Node.js 22+
- [Yarn](https://yarnpkg.com/)
- An AWS account, with the [AWS CLI](https://aws.amazon.com/cli/) installed
- [Terraform](https://developer.hashicorp.com/terraform) >= 1.5.0

## Setup

1. `yarn install`
2. Replace all `TODO`/`todo` values:
    - `src/lib/site-config.ts`
    - `package.json`
    - `static-site/backend.tf`
    - `scripts/create-tfstate-backend-bucket.sh`
    - `static-site/vars.tf` (defaults are `example.com`-style, not literal `TODO` markers)
3. `aws configure`

### Terraform

The Terraform state bucket must exist before the first `terraform apply`, and its name must be set
by hand in three places (`backend` blocks can't reference variables): `static-site/vars.tf`
(`backend_bucket_prefix`), `static-site/backend.tf` (`backend "s3" { bucket = ... }`), and
`scripts/create-tfstate-backend-bucket.sh` (`BUCKET`).

1. Update `static-site/vars.tf`.
2. Update the `TODO` references in `static-site/backend.tf`.
3. Update `scripts/create-tfstate-backend-bucket.sh` to use the same bucket name.
4. `./scripts/create-tfstate-backend-bucket.sh`
5. `cd static-site && terraform init`
6. `terraform fmt`
7. `terraform plan`
8. `terraform apply -auto-approve`
    - On first apply, check Certificate Manager in the AWS Console for a pending certificate and
      add its CNAME to your DNS (if not using Route 53).

## Usage

```sh
yarn dev       # development server
yarn build     # type-check and export the static site to out/
yarn preview   # serve the out/ build locally
```

## Testing & Quality

```sh
yarn test:unit           # Vitest
yarn test:e2e             # Playwright (run `yarn build` first)
yarn test:mutation        # StrykerJS
yarn lint / lint:check
yarn format / format:check
yarn tf:check              # terraform fmt/validate + TFLint + Trivy
```

`tf:check` and its component scripts (`tf:fmt:check`, `tf:validate`, `tf:lint`, `tf:scan`) require
`brew install terraform-linters/tap/tflint trivy`.

A pre-commit hook (Husky + lint-staged) lints and formats staged files automatically.

## CI/CD

Two equivalent pipelines are provided — use one, delete the other:

- `.circleci/config.yml`
- `.github/workflows/ci.yml` + `.github/workflows/deploy.yml`

Both require `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_REGION` set as CI
secrets/variables — separate from the local `aws configure` step above, which only configures your
own machine.

## Notes

If there are any issues, submit a pull request.
