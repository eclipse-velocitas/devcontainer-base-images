# Copyright (c) 2022 Robert Bosch GmbH and Microsoft Corporation
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

FROM ubuntu:22.04

RUN apt-get update && apt-get upgrade -y 

# install devcontainer feature prerequisites
RUN apt-get install -y apt-utils openssh-client gnupg2 dirmngr iproute2 \
        procps lsof htop net-tools psmisc manpages manpages-dev \
        curl tree wget rsync ca-certificates unzip init-system-helpers \
        bzip2 zip nano vim-tiny less jq lsb-release git zsh pigz \
        apt-transport-https dialog libc6 libgcc1 libkrb5-3 iptables \
        libgssapi-krb5-2 libicu[0-9][0-9] liblttng-ust[0-9] \
        libstdc++6 zlib1g locales sudo ncdu man-db strace gnupg2 \
        build-essential python3-dev

ADD https://raw.githubusercontent.com/devcontainers/features/main/src/common-utils/install.sh /tmp/scripts/install-common.sh
RUN UID="4000" bash /tmp/scripts/install-common.sh 
ADD https://raw.githubusercontent.com/devcontainers/features/main/src/docker-in-docker/install.sh /tmp/scripts/install-dind.sh
RUN VERSION="latest" bash /tmp/scripts/install-dind.sh

COPY ./requirements/ /requirements/
COPY ./scripts/ /scripts/

WORKDIR /scripts
RUN ./install-python.sh
RUN ./install-dapr-cli.sh
RUN ./install-k3d-prerequisites.sh
USER 4000
RUN ./install-k3d-tooling.sh

WORKDIR /requirements
# Always install requirements under vscode user to avoid issue with installation of packages
RUN pip3 install -r requirements-dev.txt
RUN pip3 install -r requirements-links.txt
RUN pip3 install -r requirements.txt
RUN pip3 install -r requirements-test.txt
# Keep root as last user
USER root
