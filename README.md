# static-site-template

Static website template using Next.js (static export), CloudFront, S3, and Terraform.

Built for real static-site SEO: each route is real pre-rendered HTML (not a client-side-rendered shell), with per-page metadata, Open Graph/Twitter Card tags, and a sitemap/robots.txt generated from the actual routes in `src/app`.

## Requirements

- Node.js 22+
- [Yarn](https://yarnpkg.com/)
- An AWS account, with the [AWS CLI](https://aws.amazon.com/cli/) installed
- [Terraform](https://developer.hashicorp.com/terraform) >= 1.5.0

## Configuration

### Replace TODO Values

Update all the `TODO` and `todo` references with the corresponding values.

- `src/lib/site-config.ts` (site name, description, URL, GTM ID, Twitter handle)
- `package.json`
- `static-site/backend.tf`
- `scripts/create-tfstate-backend-bucket.sh`

`static-site/vars.tf` doesn't use `TODO` markers — replace its `example.com`-style
defaults with your actual domain, bucket names, and region instead.

### Yarn

Run `yarn install` in the root directory to install the packages.

### AWS

Run `aws configure` and follow the prompts as necessary — do this before touching Terraform or
either CI pipeline below, since every step after this assumes AWS credentials are already
available. If the computer is already set up to use AWS, skip this step.

### Terraform

#### Steps

The Terraform state for this stack lives in its own S3 bucket, named
`${backend_bucket_prefix}-backend-terraform-state`. Since a Terraform `backend` block
can't reference a variable, that literal bucket name has to be typed in three places by
hand, and all three must match:

- `static-site/vars.tf` — the `backend_bucket_prefix` variable
- `static-site/backend.tf` — the `backend "s3" { bucket = ... }` value
- `scripts/create-tfstate-backend-bucket.sh` — the `BUCKET` value

The bucket must exist before the first `terraform apply`, because Terraform can't create
the bucket it's about to store its own state in. `backend.tf` adopts that pre-created
bucket into Terraform management via an `import` block, keyed off `backend_bucket_prefix`.

1. Update the variables in `static-site/vars.tf`, including `backend_bucket_prefix`.
2. Update the `TODO` references in `static-site/backend.tf` (`bucket` and `region`) to match.
3. Update `scripts/create-tfstate-backend-bucket.sh` to use that same bucket name.
4. Execute `./scripts/create-tfstate-backend-bucket.sh` to create the bucket.
5. Run `terraform init` from the `static-site` directory to initialize the Terraform infrastructure.
6. Run `terraform fmt` to format the code.
7. Run `terraform plan` to see what the code will do.
8. Run `terraform apply -auto-approve` to apply the code.
    1. When running this for the first time, check AWS Console for the Certificate Manager that might have a pending certificate.
        1. Add the CNAME name and value in the DNS manager for the domain name (if not using Route 53).

`static-site/cloudfront-main.tf` attaches a CloudFront Function
(`static-site/cloudfront-functions/rewrite-html-extension.js`) that appends `.html` to
extensionless requests and `index.html` to directory-style requests. This matches Next's default
static export output (e.g. `about.html`, not `about/index.html`) — without it, clean URLs like
`/about` 404 on S3/CloudFront even though the page built successfully.

The site bucket is fully private — no S3 static-website hosting, no bucket ACLs, no public access
of any kind. CloudFront reaches it via Origin Access Control (OAC), and the bucket policy only
trusts requests coming from this specific distribution. Adjust `price_class` in `vars.tf` if you
want CloudFront to use edge locations outside North America/Europe (the default,
`PriceClass_100`, is the cheapest option).

## Continuous Integration / Deployment

This template ships with two working, equivalent pipelines — pick one and delete the other once
you've decided:

- `.circleci/config.yml` (CircleCI)
- `.github/workflows/ci.yml` + `.github/workflows/deploy.yml` (GitHub Actions)

**Recommendation: GitHub Actions.** For a repo that already lives on GitHub there's no separate
account or dashboard to configure, and public repos get unlimited free Actions minutes —
CircleCI's free tier is credit-limited. CircleCI isn't doing anything here GitHub Actions can't;
keep it only if you have a specific reason to (existing CircleCI org, non-GitHub mirror, etc.).

Whichever CI you use — or if you bring your own (GitLab CI, Bitbucket Pipelines, Jenkins, ...) —
it needs the same four things:

1. **AWS credentials as CI secrets.** This is separate from the local `aws configure` step above
   — that only configures your own machine, not the CI runner. Forgetting to add credentials to
   your CI platform is the most common way this pipeline breaks on first use.
    - GitHub Actions: repo Settings → Secrets and variables → Actions — add `AWS_ACCESS_KEY_ID`
      and `AWS_SECRET_ACCESS_KEY` as secrets, `AWS_REGION` as a variable.
    - CircleCI: Project Settings → Environment Variables.
2. **Checks**: `yarn run format:check`, `yarn run lint:check`, `yarn run type-check`,
   `yarn run test:unit`, `yarn run build`.
3. **Terraform read-only checks** — `init` → `validate` → `fmt -check` → TFLint → Trivy config
   scan, run from `static-site/`. No AWS credentials needed for any of these; both pipelines run
   them on every PR/branch, not just `master`, so problems surface before merge instead of during
   deploy. See [Terraform Checks](#terraform-checks) below.
4. **Terraform plan/apply** — needs AWS credentials and the state bucket from the Terraform setup
   above to already exist; runs only on push to `master`.
5. **Deploy**: sync `out/` to the S3 bucket (`terraform output -raw bucket_name`), then invalidate
   CloudFront (`terraform output -raw cloudfront_distribution`).

## Testing

- **Unit** ([Vitest](https://vitest.dev/) + React Testing Library): `yarn run test:unit`
- **End-to-end** ([Playwright](https://playwright.dev/)): `yarn run test:e2e` — starts
  `yarn preview` automatically against a `yarn build` output (run `yarn build` first).
- **Mutation** ([StrykerJS](https://stryker-mutator.io/)): `yarn run test:mutation` — checks that
  the unit tests actually catch bugs, not just that they pass. HTML report at
  `reports/mutation/mutation.html`. The score is currently informational
  (`thresholds.break: null` in `stryker.config.json`), since only `page.tsx` and `routes.ts` have
  unit tests so far — tighten the threshold as coverage grows.

## Terraform Checks

[TFLint](https://github.com/terraform-linters/tflint) (correctness/best-practices, with the AWS
ruleset plugin) and [Trivy](https://trivy.dev/) (`trivy config`, security misconfiguration
scanning — the modern replacement for the now-deprecated tfsec) run against `static-site/` on
every PR in both CI pipelines. Neither is installed via `yarn` — they're standalone binaries, not
npm packages — and neither runs in the pre-commit hook, so cloning this template and running
`yarn install` never requires installing them. They only matter if you're editing the Terraform.

To run them locally and get the same result CI will, install once via Homebrew:

```sh
brew install terraform-linters/tap/tflint trivy
```

Then, from the repo root:

```sh
yarn run tf:check       # everything CI runs: fmt check, validate, TFLint, Trivy
yarn run tf:fmt:check
yarn run tf:validate
yarn run tf:lint
yarn run tf:scan
```

A handful of Trivy findings are intentionally suppressed with inline `# trivy:ignore:<ID>`
comments rather than fixed, because the underlying rule doesn't fit this template's design:

- **AWS-0132** (S3 should use customer-managed KMS keys) — SSE-S3 (AES256, already applied) is
  sufficient here; SSE-KMS adds per-request cost and key-management overhead disproportionate to
  a static site template.
- **AWS-0320** (S3 bucket names should be DNS-compliant) — the dots in the bucket name are
  intentional (`bucket_name` is domain-derived, e.g. `app.example.com`); the risk this rule guards
  against (broken TLS for virtual-hosted-style public S3 URLs) doesn't apply since the bucket is
  private and only ever reached via CloudFront/OAC over SigV4, never a direct public HTTPS URL.
- **AWS-0089** (S3 bucket should have access logging enabled) — CloudFront's own `logging_config`
  already captures all real traffic to the site bucket; S3-level access logging would be
  redundant.
- **AWS-0011** (CloudFront distribution should have a WAF) — a real hardening option, but AWS WAF
  has an ongoing cost or complexity disproportionate to force on by default for every site built
  from this template. Add `aws_wafv2_web_acl` yourself if your deployment needs it.

## Quality Tooling

- **Lint** ([ESLint](https://eslint.org/)): `yarn run lint` (fixes in place, for local use) /
  `yarn run lint:check` (no mutation, used in CI).
- **Format** ([Prettier](https://prettier.io/)): `yarn run format` (fixes in place) /
  `yarn run format:check` (CI).
- **Security scanning**: [CodeQL](https://codeql.github.com/) runs on every push/PR and weekly via
  `.github/workflows/codeql.yml` (free for public GitHub repos), covering the app code. Trivy
  covers the Terraform side — see [Terraform Checks](#terraform-checks). Security vulnerability
  alerts are already enabled on this repo; `.github/dependabot.yml` additionally schedules weekly
  version-update PRs for npm packages, GitHub Actions, and the Terraform provider, grouping
  minor/patch bumps together to cut down on PR noise.
- **Pre-commit hook**: [Husky](https://typicode.github.io/husky/) + [lint-staged](https://github.com/lint-staged/lint-staged)
  lint/format staged files on commit automatically — set up by `yarn install` (`prepare` script),
  no manual step needed.

## Notes

If there are any issues, submit a pull request.

## Project Setup

```sh
yarn install
```

### Development Server

```sh
yarn dev
```

### Build the Static Site

```sh
yarn build
```

Type-checks and outputs the site to `out/`, ready to sync to S3 as-is.

### Preview the Built Static Site Locally

```sh
yarn preview
```

See the [Testing](#testing) and [Quality Tooling](#quality-tooling) sections above for lint,
format, and test commands.
