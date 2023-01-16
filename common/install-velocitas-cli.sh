#!/bin/bash
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

echo "#######################################################"
echo "### Install Velocitas CLI                           ###"
echo "#######################################################"

CLI_ASSET_NAME=velocitas-linux-$(echo $1 | sed 's/amd64/x64/g')
CLI_INSTALL_PATH=/usr/bin/velocitas

CLI_DOWNLOAD_URL="https://github.com/eclipse-velocitas/cli/releases/latest/download/${CLI_ASSET_NAME}"

curl -L ${CLI_DOWNLOAD_URL} -o "${CLI_INSTALL_PATH}"
chmod +x "${CLI_INSTALL_PATH}"

CLI_VERSION=$( "${CLI_INSTALL_PATH}" --version )

echo "CLI version: ${CLI_VERSION}" 
