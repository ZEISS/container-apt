# APT - Automated Provisioning Tools

[![github_actions_badge]][github_actions]
[![github_releases_badge]][github_releases]
[![github_container_badge]][github_container]

This image contains tools around [Ansible](https://www.ansible.com/), [Packer](https://www.packer.io/) and [Terraform](https://www.terraform.io/) for automated provisioning of infrastructures:

* Microsoft Azure
* Amazon Web Services
* On-Premises

The main purpose of this image is to act as a control node for development of declerative infrastructure as code (IaC) and configuration management (CM) used in CI/CD pipelines.

## Getting Started

### Prerequisities

* [Docker Engine](https://docs.docker.com/get-docker/)

> **Optional**: Install a [Nerd Font](https://www.nerdfonts.com/font-downloads) on the system and configure the used terminal (e.g. [VS Code integrated terminal](https://code.visualstudio.com/docs/editor/integrated-terminal#_terminal-display-settings)) to display all icons within the container's shell or editor.

### Usage

By default this container is running infinitly, if started in detached mode. Mount volumes on container start to share IaC and CM files with the provisioning tools inside the container.

Run container:

```shell
# Docker on Linux or Mac
docker run --rm -d \
    -v "${pwd}:/srv" \
    --name apt ghcr.io/zeiss-digital-innovation/apt

# Docker on Windows
docker run --rm -d `
    -v "${pwd}:/srv" `
    --name apt ghcr.io/zeiss-digital-innovation/apt
```

> **Note**: Follow the *[File Sharing](https://docs.docker.com/docker-for-windows/#resources)* section for prerequisities, if running Docker on Windows in Hyper-V mode.

Jump into running container:

```shell
docker exec -it apt bash
```

Run container with custom command:

```shell
# Docker on Linux or Mac
docker run --rm -it -v "${PWD}:/srv" ghcr.io/zeiss-digital-innovation/apt \
    CMD

# Docker on Windows
docker run --rm -it -v "${PWD}:/srv" ghcr.io/zeiss-digital-innovation/apt `
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

[github_actions]: https://github.com/zeiss-digital-innovation/container-apt/actions?query=workflow%3Acontainer
[github_actions_badge]: https://img.shields.io/github/workflow/status/zeiss-digital-innovation/container-apt/docker-build/master?logo=github
[github_releases]: https://github.com/zeiss-digital-innovation/container-apt/releases
[github_releases_badge]: https://img.shields.io/github/v/release/zeiss-digital-innovation/container-apt?sort=semver&logo=github
[github_container]: https://github.com/orgs/zeiss-digital-innovation/packages/container/package/apt
[github_container_badge]: https://img.shields.io/badge/image-ghcr.io%2Fzeiss--digital--innovation%2Fapt-1488C6?logo=docker&logoColor=FFF
[github_issue]: http://github.com/zeiss-digital-innovation/container-apt/issues/new/choose
[github_guide]: http://github.com/zeiss-digital-innovation/container-apt/tree/master/.github/CONTRIBUTING.md
[github_licence]: http://github.com/zeiss-digital-innovation/container-apt/tree/master/LICENSE
