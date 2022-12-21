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
echo "### Install dapr-cli                                     ###"
echo "#######################################################"

DEFAULT_DAPR_CLI_VERSION=$(cat AppManifest.json | jq .[].dependencies.dapr.cli.version | tr -d '"')

INSTALLED_DAPR_CLI_VERSION=$(dapr --version | grep "CLI version: " | sed 's/^.*: //' | sed 's/\s*//g')

# Check dapr CLI
if [ "${INSTALLED_DAPR_CLI_VERSION}" != "${DEFAULT_DAPR_CLI_VERSION}" ]; then
      echo "Install dapr CLI $DEFAULT_DAPR_CLI_VERSION"
      wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash -s $DEFAULT_DAPR_CLI_VERSION
else
      echo "Dapr CLI $DEFAULT_DAPR_CLI_VERSION is already installed."
fi
