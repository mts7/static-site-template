# static-site-template
Static web site template using Vue, CloudFront, S3, and Terraform

## Configuration

### AWS

Run `aws configure` and follow the prompts as necessary.

If the computer is already set up to use AWS, skip this step.

### Terraform

#### Steps

1. Update the variables in `static-site/vars.tf`.
2. Update all the `todo` or `TODO` references in the `static-site/backend.tf` file.
3. Run `terraform init` from the `static-site` directory to initialize the Terraform infrastructure.
   1. The S3 bucket might need to exist before initializing Terraform. 
   If it does, this static site template should attempt to create the bucket.

### Vue

Update all the `TODO` and `todo` references with the corresponding values.
- index.ts
- App.vue
- google-tag-manager.js
- package.json
- index.html

### Yarn

Run `yarn install` in the root directory to install the packages.

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

