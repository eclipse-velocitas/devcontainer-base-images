# Copyright (c) 2022 Robert Bosch GmbH
#
# This program and the accompanying materials are made available under the
# terms of the Apache License, Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# SPDX-License-Identifier: Apache-2.0

##############################################################################
# Builder step (cross compile from BUILD to HOST, if needed)
##############################################################################

FROM --platform=$BUILDPLATFORM ubuntu:22.04 as builder

RUN apt-get update && apt-get upgrade -y && \
        apt-get install -y apt-utils openssh-client gnupg2 dirmngr iproute2 \
        procps lsof htop net-tools psmisc manpages manpages-dev \
        curl wget ca-certificates unzip init-system-helpers \
        bzip2 zip git zsh pigz \
        apt-transport-https dialog libkrb5-3 \
        libgssapi-krb5-2 libicu[0-9][0-9] liblttng-ust[0-9] \
        locales sudo ncdu cmake \
        build-essential build-essential \
        gcc-aarch64-linux-gnu g++-aarch64-linux-gnu binutils-aarch64-linux-gnu \
        gcc-x86-64-linux-gnu g++-x86-64-linux-gnu binutils-x86-64-linux-gnu && \
        apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*


ADD https://raw.githubusercontent.com/devcontainers/features/7fa90110d762797cc0b1c2fe8fcc028c9b813d56/src/common-utils/install.sh /container/scripts/install-common.sh
RUN UID="4000" bash /container/scripts/install-common.sh 

ADD --chown=4000 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-cpp-sdk/main/conanfile.py /container/cpp/

# Get all profiles from the SDK
ADD --chown=4000 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-cpp-sdk/main/.conan/profiles/linux_aarch64_release /container/cpp/.conan/profiles/
ADD --chown=4000 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-cpp-sdk/main/.conan/profiles/linux_x86_64_release  /container/cpp/.conan/profiles/
ADD --chown=4000 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-cpp-sdk/main/.scripts/common.sh                    /container/cpp/.scripts/
ADD --chown=4000 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-cpp-sdk/main/install_dependencies.sh               /container/cpp/
ADD --chown=4000 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-cpp-sdk/main/requirements.txt                      /container/cpp/   

COPY ./common/ /scripts/

# Install conan
WORKDIR /scripts
RUN ./install-python.sh && pip3 install -r /container/cpp/requirements.txt

# Build dependencies for target architecture 
WORKDIR /container/cpp
USER 4000
WORKDIR /container/cpp/build
WORKDIR /container/cpp
ARG TARGETARCH
RUN bash ./install_dependencies.sh -x $TARGETARCH

# Remove build files for final image
RUN conan remove --builds --src --force '*'


##############################################################################
# Final step (run on TARGET, QEMU if needed)
##############################################################################

FROM --platform=$TARGETPLATFORM ubuntu:22.04 as final

RUN apt-get --fix-missing update && apt-get upgrade -y && \
        apt-get install -y apt-utils openssh-client gnupg2 dirmngr iproute2 \
        procps lsof htop net-tools psmisc manpages manpages-dev \
        curl tree wget ca-certificates unzip init-system-helpers \
        bzip2 zip nano vim-tiny less jq lsb-release git zsh pigz \
        apt-transport-https dialog libgcc1 libkrb5-3 iptables \
        libgssapi-krb5-2 libicu[0-9][0-9] liblttng-ust[0-9] \
        libstdc++6 zlib1g locales sudo ncdu man-db strace gnupg2 \
        # install cpp packages
        build-essential cmake clang lldb llvm gdb ninja-build cppcheck clang-format-14 clang-tidy-14 && \
        # clean-up
        apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
        # redirect format and tidy to the versioned variants
        update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-14 100 && \
        update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-14 100

ADD https://raw.githubusercontent.com/devcontainers/features/7fa90110d762797cc0b1c2fe8fcc028c9b813d56/src/common-utils/install.sh /container/scripts/install-common.sh
RUN UID="4000" bash /container/scripts/install-common.sh 
ADD https://raw.githubusercontent.com/devcontainers/features/7fa90110d762797cc0b1c2fe8fcc028c9b813d56/src/docker-in-docker/install.sh /container/scripts/install-dind.sh
RUN VERSION="latest" bash /container/scripts/install-dind.sh

COPY ./common/ /scripts/

WORKDIR /scripts
RUN ./install-python.sh && \
    ./install-dapr-cli.sh && \
    ./install-k3d-prerequisites.sh \
    ./install-k3d-tooling.sh

USER 4000
ADD --chown=4000 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-cpp-sdk/main/requirements.txt  /container/requirements.txt
# Install Python requirements as vscode user and clean up
RUN pip3 install -r /container/requirements.txt && sudo rm /container/requirements.txt

# We need to set the USER back to root at the end, otherwise we get errors when using this in our repo.
USER root

# Obtain pre-build dependencies
COPY --from=builder /home/vscode/.conan /home/vscode/.conan
