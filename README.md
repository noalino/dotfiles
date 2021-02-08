# My containerized dotfiles config

It handles user permission to avoid experiencing files permission issues when working with local volumes.

Unix/Linux installation:
`$ docker build -t <container_name> --build-arg USER_ID=$(id -u) --build-arg USER_NAME=$(id -un) .`
