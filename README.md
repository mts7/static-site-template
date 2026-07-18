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
3. **Terraform**, run from `static-site/`: `init` → `validate` → `fmt -check` → `plan` → `apply`
   (the state bucket from the Terraform setup above must already exist).
4. **Deploy**: sync `out/` to the S3 bucket (`terraform output -raw bucket_name`), then invalidate
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

## Quality Tooling

- **Lint** ([ESLint](https://eslint.org/)): `yarn run lint` (fixes in place, for local use) /
  `yarn run lint:check` (no mutation, used in CI).
- **Format** ([Prettier](https://prettier.io/)): `yarn run format` (fixes in place) /
  `yarn run format:check` (CI).
- **Security scanning**: [CodeQL](https://codeql.github.com/) runs on every push/PR and weekly via
  `.github/workflows/codeql.yml` (free for public GitHub repos). Security vulnerability alerts are
  already enabled on this repo; `.github/dependabot.yml` additionally schedules weekly version-update
  PRs for npm packages, GitHub Actions, and the Terraform provider, grouping minor/patch bumps
  together to cut down on PR noise.
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
