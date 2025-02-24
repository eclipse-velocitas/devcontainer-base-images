# Copyright (c) 2022-2025 Contributors to the Eclipse Foundation
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

ARG SDK_TAG

WORKDIR /container/cpp/

RUN echo $SDK_TAG > version.txt


RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y jq sudo curl wget git cmake build-essential \
    gcc-aarch64-linux-gnu g++-aarch64-linux-gnu binutils-aarch64-linux-gnu \
    gcc-x86-64-linux-gnu g++-x86-64-linux-gnu binutils-x86-64-linux-gnu && \
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ADD --chmod=444 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-cpp-sdk/$SDK_TAG/conanfile.py .

# Get all profiles from the SDK
ADD --chmod=444 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-cpp-sdk/$SDK_TAG/.conan/profiles/*          ./.conan/profiles/
ADD --chmod=744 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-cpp-sdk/$SDK_TAG/.scripts/common.sh         ./.scripts/
ADD --chmod=744 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-cpp-sdk/$SDK_TAG/install_dependencies.sh    .
ADD --chmod=444 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-cpp-sdk/$SDK_TAG/requirements.txt           .

COPY ./common /scripts

WORKDIR /conan
ENV CONAN_USER_HOME /conan

# Install conan
WORKDIR /scripts
RUN ./install-python.sh && pip3 install -r /container/cpp/requirements.txt

# Build dependencies for target architecture
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

ARG SDK_TAG

RUN apt-get --fix-missing update && apt-get upgrade -y && \
    apt-get install -y jq sudo curl wget git \
    # install cpp packages
    build-essential cmake clang lldb llvm gdb ninja-build cppcheck clang-format-14 clang-tidy-14 && \
    # clean-up
    apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    # redirect format and tidy to the versioned variants
    update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-14 100 && \
    update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-14 100

# Create non-root user
ARG USERNAME=vscode
ARG USER_UID=4000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

WORKDIR /tmp/setup
COPY ./common .

ARG TARGETARCH
RUN ./install-python.sh && \
    ./install-velocitas-cli.sh ${TARGETARCH} && \
    ./install-kanto.sh ${TARGETARCH}

# Install conan as root user
RUN sudo pip3 install conan==2.12.2

USER 4000

ADD --chown=4000 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-cpp-sdk/$SDK_TAG/requirements.txt ./requirements/requirements.txt

# Install Python requirements as vscode user and clean up
RUN sudo pip3 install -r ./requirements/requirements.txt && \
    sudo pip3 install -r ./requirements.txt

# We need to set the USER back to root at the end, otherwise we get errors when using this in our repo.
USER root
WORKDIR /

# Cleanup temporary files
RUN rm -rf /tmp/setup

# Obtain pre-build dependencies
COPY --chown=4000 --from=builder /conan/.conan /home/vscode/.conan
