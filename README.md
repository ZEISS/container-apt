# APT - Automated Provisioning Tools

[![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/zeiss-digital-innovation/docker-apt/docker-build/master?logo=github&label=build)][github_actions]
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/zeiss-digital-innovation/docker-apt?sort=semver&logo=github)][github_releases]
[![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/zeiss-digital-innovation/apt?label=image&logo=docker&logoColor=FFF&sort=semver)](https://hub.docker.com/r/zeiss-digital-innovation/apt)

This image contains tools around [Ansible](https://www.ansible.com/), [Packer](https://www.packer.io/) and [Terraform](https://www.terraform.io/) for automated provisioning of infrastructures:

* Microsoft Azure
* Amazon Web Services
* On-Premises

The main purpose of this image is to act as a control node for the development of declerative infrastructure as code (IaC) and configuration management (CM) used in CI/CD pipelines.

## Getting Started

### Prerequisities

* [Docker Engine](https://docs.docker.com/get-docker/)

> **Note**: Install a [Nerd Font](https://www.nerdfonts.com/font-downloads) on the system and configure the used terminal (e.g. [VS Code integrated terminal](https://code.visualstudio.com/docs/editor/integrated-terminal#_terminal-display-settings)) to display all icons within the container's shell or editor.

### Usage

By default this container is running infinitly, if started in detached mode. Mount volumes on container start to share IaC and CM files with the provisioning tools inside the container.

Run container:

```shell
# Docker on Linux or Mac
docker run --rm -d \
    -v "${pwd}:/srv" \
    --name apt zeiss-digital-innovation/apt

# Docker on Windows
docker run --rm -d `
    -v "${pwd}:/srv" `
    --name apt zeiss-digital-innovation/apt
```

> **Note**: Follow the *[File Sharing](https://docs.docker.com/docker-for-windows/#resources)* section for prerequirements, if running Docker on Windows in Hyper-V mode.

Jump into running container:

```shell
docker exec -it apt bash
```

Run container with custom command:

```shell
# Docker on Linux or Mac
docker run --rm -it -v "${pwd}:/srv" zeiss-digital-innovation/apt \
    CMD

# Docker on Windows
docker run --rm -it -v "${pwd}:/srv" zeiss-digital-innovation/apt `
    CMD
```

> **Note**: Connections from this container to the docker host can be established with the special DNS name `host.docker.internal` which resolves to the internal IP address used by the host.

#### Useful File Locations

* `/usr/local/share/hashicorp/install.sh` - [HashiCorp binaries install script](https://github.com/zeiss-digital-innovation/install-hashicorp-binaries)
* `/usr/local/etc/dehydrated` - [dehydrated](https://github.com/dehydrated-io/dehydrated) base directory
* `/usr/local/etc/dehydrated/hooks/lexicon.sh` - [dns-lexicon](https://github.com/AnalogJ/lexicon) hook script

## Contributing

If you find issues, please register them at this [GitHub project issue page][github_issue] or consider contributing code by following this [guideline][github_guide].

## Authors

* [Brian Rimek](https://github.com/rembik)

## License

This project is licensed under the MIT License - see the [LICENSE][github_licence] file for details.

[github_actions]: https://github.com/zeiss-digital-innovation/docker-apt/actions
[github_releases]: https://github.com/zeiss-digital-innovation/docker-apt/releases
[github_issue]: http://github.com/zeiss-digital-innovation/docker-apt/issues/new/choose
[github_guide]: http://github.com/zeiss-digital-innovation/docker-apt/tree/master/.github/CONTRIBUTING.md
[github_licence]: http://github.com/zeiss-digital-innovation/docker-apt/tree/master/LICENSE