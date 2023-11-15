# static-site-template
Static website template using Vue, CloudFront, S3, and Terraform

## Configuration

### Replace TODO Values

Update all the `TODO` and `todo` references with the corresponding values.
- index.ts
- App.vue
- google-tag-manager.js
- package.json
- index.html
- create-tfstate-backend-bucket.sh

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

There might be issues with `src/router/index.ts`. If there are, submit a pull request to this repository.

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

### Type-Check, Compile and Minify for Production

```sh
yarn build
```

### Run Unit Tests with [Vitest](https://vitest.dev/)

```sh
yarn test:unit
```

### Lint with [ESLint](https://eslint.org/)

```sh
yarn lint
```

