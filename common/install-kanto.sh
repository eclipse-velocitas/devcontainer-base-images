#!/bin/bash
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
set -e
echo "#######################################################"
echo "### Install Kanto ${KANTO_VERSION}                        ###"
echo "#######################################################"
KANTO_VERSION='1.0.0' # reference on particular release version

ARCH=$(echo $1 | sed 's/amd64/x86_64/g')
KANTO_DOWNLOAD_URL=https://github.com/eclipse-kanto/kanto/releases/download/v${KANTO_VERSION}/kanto_${KANTO_VERSION}_linux_${ARCH}.deb

echo "Downloading Kanto from ${KANTO_DOWNLOAD_URL}"

wget ${KANTO_DOWNLOAD_URL}

# install prerequisites of Kanto
sudo apt-get update && sudo apt-get install -y mosquitto containerd iptables

sudo dpkg -i ./kanto_${KANTO_VERSION}_linux_${ARCH}.deb


echo "#######################################################"
echo "### Install KantUI ${KANTUI_VERSION}                      ###"
echo "#######################################################"
KANTUI_VERSION='0.0.3' # reference on particular release version
KANTUI_HASH='861'

KANTUI_DOWNLOAD_URL=https://github.com/eclipse-leda/leda-utils/releases/download/v${KANTUI_VERSION}/eclipse-leda-kantui_${KANTUI_VERSION}.0.${KANTUI_HASH}_$1.deb

echo "Downloading KantUI from ${KANTUI_DOWNLOAD_URL}"

wget ${KANTUI_DOWNLOAD_URL}
sudo dpkg -i ./eclipse-leda-kantui_${KANTUI_VERSION}.0.${KANTUI_HASH}_$1.deb
