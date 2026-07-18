# static-site-template
Static website template using Next.js (static export), CloudFront, S3, and Terraform.

Built for real static-site SEO: each route is real pre-rendered HTML (not a client-side-rendered shell), with per-page metadata, Open Graph/Twitter Card tags, and generated `sitemap.xml`/`robots.txt`.

`src-vue/` is the previous Vue implementation, kept for reference only — it is not part of the build.

## Configuration

### Replace TODO Values

Update all the `TODO` and `todo` references with the corresponding values.
- `src/lib/site-config.ts` (site name, description, URL, GTM ID, Twitter handle)
- `package.json`
- `static-site/vars.tf`
- `static-site/backend.tf`
- `create-tfstate-backend-bucket.sh`

### Yarn

Run `yarn install` in the root directory to install the packages.

### AWS

Run `aws configure` and follow the prompts as necessary.

If the computer is already set up to use AWS, skip this step.

### Terraform

#### Steps

1. Update the variables in `static-site/vars.tf`.
2. Update all the `todo` or `TODO` references in the `static-site/backend.tf` file.
3. Verify `create-tfstate-backend-bucket.sh` uses the same bucket name as in `backend.tf`.
4. Execute `./scripts/create-tfstate-backend-bucket.sh` to create the bucket. 
5. Run `terraform init` from the `static-site` directory to initialize the Terraform infrastructure.
6. Run `terraform fmt` to format the code.
7. Run `terraform plan` to see what the code will do.
8. Run `terraform apply -auto-approve` to apply the code.
   1. When running this for the first time, check AWS Console for the Certificate Manager that might have a pending certificate.
      1. Add the CNAME name and value in the DNS manager for the domain name (if not using Route 53).

## Notes

If there are any issues, submit a pull request.

Attempt to keep the Yarn packages up-to-date. We might want to consider using `dependabot` or similar for that.

## Project Setup

```sh
yarn install
```

### Compile and Hot-Reload for Development

```sh
yarn dev
```

### Type-Check and Build the Static Site

```sh
yarn build
```

Output is written to `out/`, ready to sync to S3 as-is.

### Preview the Built Static Site Locally

```sh
yarn preview
```

### Run Unit Tests with [Vitest](https://vitest.dev/)

```sh
yarn test:unit
```

### Lint with [ESLint](https://eslint.org/)

```sh
yarn lint
```
