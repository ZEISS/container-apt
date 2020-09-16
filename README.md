# Ansible Controller

[![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/rembik/docker-ansible-controller/docker-ci/master?logo=github&label=build)](https://github.com/rembik/docker-ansible-controller/actions)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/rembik/docker-ansible-controller?logo=github)](https://github.com/rembik/docker-ansible-controller/releases)
[![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/rembik/ansible-controller?label=image&logo=docker&logoColor=FFF&sort=semver)](https://hub.docker.com/r/rembik/ansible-controller)

Ansible control node as container for development or local CI/CD purposes.

## Getting Started

 The container image provide infrastucture as code (IaC) tools for imperative configuration management (CM) via Ansible on:

* Microsoft Azure
* Amazon Web Services
* On-Premise

### Prerequisities

* [Docker Engine](https://docs.docker.com/get-docker/)

### Usage

By default this container is running infinitly, if started in detached mode.

#### Container Parameters

Run container with shared volumes to persist and execute IaC from the inside:

```shell
# Docker on Linux or Mac
docker run --rm -d \
    - v /host/path:/container/path \
    --name ansible_controller rembik/ansible-controller

# Docker on Windows
docker run --rm -d `
    - v /drive/host/path:/container/path `
    --name ansible_controller rembik/ansible-controller
```

> **Note**: Follow the *[File Sharing](https://docs.docker.com/docker-for-windows/#resources)* section for prerequirements, if running Docker on Windows in Hyper-V mode.

Jump into the running container:

```shell
docker exec -it ansible_controller bash
```

> **Note**: Connections from this container to the docker host can be established with the special DNS name `host.docker.internal` which resolves to the internal IP address used by the host.

#### Useful File Locations

* `/usr/local/etc/dehydrated` - [dehydrated](https://github.com/dehydrated-io/dehydrated) base directory
* `/usr/local/etc/dehydrated/hooks/lexicon.sh` - [dns-lexicon](https://github.com/AnalogJ/lexicon) hook script

## Contributing

If you find issues, please register them at this [GitHub project issue page](https://github.com/rembik/docker-ansible-controller/issues/new/choose) or consider contributing code by following this [guideline](http://github.com/rembik/docker-ansible-controller/tree/master/.github/CONTRIBUTING.md).

## Authors

* [Brian Rimek](https://github.com/rembik)

## License

This project is licensed under the MIT License - see the [LICENSE](http://github.com/rembik/docker-ansible-controller/tree/master/github/LICENSE) file for details.
