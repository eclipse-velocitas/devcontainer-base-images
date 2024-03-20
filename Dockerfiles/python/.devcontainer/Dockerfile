# Copyright (c) 2022-2024 Contributors to the Eclipse Foundation
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

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y jq sudo curl wget git

# Create non-root user
ARG USERNAME=vscode
ARG USER_UID=4000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

WORKDIR /tmp/setup
COPY ./common .

ARG TARGETARCH
RUN ./install-python.sh && \
    ./install-velocitas-cli.sh ${TARGETARCH} && \
    ./install-kanto.sh ${TARGETARCH}

USER 4000

# Fetch requirements into requirements folder
ADD --chown=4000 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-python-template/main/requirements.txt ./requirements/dev/requirements.txt
ADD --chown=4000 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-python-template/main/app/requirements-links.txt ./requirements/app/requirements-links.txt
ADD --chown=4000 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-python-template/main/app/requirements.txt ./requirements/app/requirements.txt
ADD --chown=4000 https://raw.githubusercontent.com/eclipse-velocitas/vehicle-app-python-template/main/app/tests/requirements.txt ./requirements/tests/requirements.txt

# Always install requirements under vscode user to avoid issue with installation of packages
RUN pip3 install -r ./requirements/dev/requirements.txt && \
    pip3 install -r ./requirements/app/requirements-links.txt && \
    pip3 install -r ./requirements/app/requirements.txt && \
    pip3 install -r ./requirements/tests/requirements.txt && \
    pip3 install -r ./requirements.txt

# Keep root as last user
USER root
WORKDIR /

# Cleanup temporary files
RUN rm -rf /tmp/setup
