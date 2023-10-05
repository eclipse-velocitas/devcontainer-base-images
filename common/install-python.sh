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
set -e

echo "#######################################################"
echo "### Installing python version 3                     ###"
echo "#######################################################"
PYTHON_VERSION=$(cat AppManifest.json | jq .[].dependencies.python.version | tr -d '"')

sudo apt-get update && apt-get install -y python3-distutils python$PYTHON_VERSION && apt-get install python3-dev
curl -fsSL https://bootstrap.pypa.io/get-pip.py | sudo python$PYTHON_VERSION

sudo update-alternatives --install /usr/bin/python python /usr/bin/python$PYTHON_VERSION 10
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python$PYTHON_VERSION 10
