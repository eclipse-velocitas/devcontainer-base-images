#!/bin/bash
# Copyright (c) 2022-2026 Contributors to the Eclipse Foundation
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
set -e

echo "#######################################################"
echo "### Installing python version 3                     ###"
echo "#######################################################"

sudo apt-get update && apt install -y python3 python3-pip python3-venv python3-setuptools python3-dev pipx
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10
pipx ensurepath
pipx install pip-tools
