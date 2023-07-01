# Gitlab End to End With Docker and Terraform
## _The Last Markdown Editor, Ever_

## Features

- docker pass storage is encrypted now
- Auto registration with gitlab.com as a runner

## Installation

> Note: Replace the below in init.sh:
- [your_gitlab_token] - Gitlab runner registration token
- [your_docker_pass]  - docker_pass is base64 encoded

```sh
terraform init
terraform apply
````

#### Building for source

For production release:

```sh
docker build -t registry.gitlab.com/xxx
```


## License

MIT

**Free Software, Hell Yeah!**