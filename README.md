> Note:
This is the repository for the base-images of the devcontainers for Vehicle App Development.

> [!IMPORTANT]
> We successfully migrated our C++ repositories to use version 2 of the [Conan package manager](https://conan.io/).
> Unfortunately, those changes are not backwards compatible. So, please be aware that versions >= 0.4 of the C++ base image
> are required to be used by [Velocitas C++ SDK](https://github.com/eclipse-velocitas/vehicle-app-cpp-sdk) versions >= 0.7.0,
> and recent versions (everything since the `conan2` tag) of the [Velocitas C++ app template](https://github.com/eclipse-velocitas/vehicle-app-cpp-template).
>
> This is does not affect the Python related app template and SDK repositories.


# Vehicle App Development

![CI Workflow](https://github.com/eclipse-velocitas/devcontainer-base-images/actions/workflows/build-base-images.yml/badge.svg#branch=main)
[![License: Apache](https://img.shields.io/badge/License-Apache-yellow.svg)](http://www.apache.org/licenses/LICENSE-2.0)

## Documentation
* [Velocitas Development Model](https://eclipse.dev/velocitas/docs/concepts/development_model/)
* [Vehicle App SDK Overview](https://eclipse.dev/velocitas/docs/concepts/development_model/vehicle_app_sdk/)

## Quickstart Tutorials
1. [Setup and Explore Development Environment](https://eclipse.dev/velocitas/docs/tutorials/quickstart/)
1. [Develop your own Vehicle Model](https://eclipse.dev/velocitas/docs/tutorials/vehicle_model_creation/)
1. [Develop your own Vehicle App](https://eclipse.dev/velocitas/docs/tutorials/vehicle_app_development/)

## Contribution
- [GitHub Issues](https://github.com/eclipse-velocitas/devcontainer-base-images/issues)
- [Mailing List](https://accounts.eclipse.org/mailing-list/velocitas-dev)
- [Contribution](CONTRIBUTING.md)
