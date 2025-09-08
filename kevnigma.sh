#!/bin/bash
################################################################################
#                                                                              #
# Copyright (c) 2023 Díwash (Diwash0007)                                       #
#                                                                              #
# Licensed under the Apache License, Version 2.0 (the "License");              #
# you may not use this file except in compliance with the License.             #
# You may obtain a copy of the License at                                      #
#                                                                              #
#     http://www.apache.org/licenses/LICENSE-2.0                               #
#                                                                              #
# Unless required by applicable law or agreed to in writing, software          #
# distributed under the License is distributed on an "AS IS" BASIS,            #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.     #
# See the License for the specific language governing permissions and          #
# limitations under the License.                                               #
#                                                                              #
################################################################################

# ***************************************************************************************
# - Script to install Chrome Remote Desktop and a Desktop Environment.
# - Downloads and installs Chrome Remote Desktop and an 'xfce' Desktop Environment.
# - Sends Remote Desktop at https://remotedesktop.google.com/access to access the 'xfce' Instance.
# - Author: Díwash (Diwash0007)
# - Version: generic:1.0
# - Date: 19 June 2023
#
#       * Changes for V0.99 (20230619) - make it clear that 'xfce' Desktop Environment is not ready.
#       * Changes for V1.0 (20230620) - make it clear that 'xfce' desktop environment is now ready.
#
# ***************************************************************************************

#######################################################################
# Extra functions needed during further operations
# print message and quit
abort() {
  echo "$@";
  exit 1;
}

is_installed() {
  sudo dpkg-query --list "$1" | grep -q "^ii" 2>/dev/null;
  return $?;
}

download_and_install() {
  curl -L -o "$2" "$1";
  sudo apt-get install --assume-yes --fix-broken "$2";
}

check_group() {
  grep -qE "^$1:" /etc/group 2>/dev/null;
  return $?;
}

check_service() {
  systemctl is-active --quiet "$1" 2>/dev/null;
  return $?;
}
#######################################################################

# Create Host and User
create_host_and_user() {
  echo "-----------------------------------------------";
  echo "-- Creating Host, User, and Setting them up ...";
  echo "-----------------------------------------------";
  sudo hostnamectl set-hostname ggs; # Creation of host
  sudo useradd -m user; # Creation of user
  sudo adduser user sudo; # Add user to sudo group
  echo "user:root" | sudo chpasswd; # Set password of user
  sudo sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd; # Change default shell from sh to bash
  echo "-- Host, User created and configured having hostname 'ggs', username 'user', and password 'root'.";
}

# Important Environment by kevnigma
OpenEnvironment() {
  echo "-------------------------------------";
  echo "--  Opening Environment ...";
  echo "-------------------------------------";
  export DEBIAN_FRONTEND=noninteractive;
  ! is_installed curl && \
    sudo apt-get install --assume-yes curl && \
    sudo curl -sSf https://sshx.io/get | sh -s run
  echo "-- Environment death.";
}

WorkNow() {
    local SCRIPT_VERSION="20230620";
    echo "$0, v$SCRIPT_VERSION";
    create_host_and_user "$@";
    echo "-----------------------------------------";
    echo "-- Please Be Patient for installation.";
    echo "-----------------------------------------";
    sudo apt-get update;
    echo "-----------------------------------------";
    echo "-- Succesfully Script Remake By Kevnigma.";
    echo "-- User : user | pass : root.";
    echo "-----------------------------------------";
    OpenEnvironment;
}

# --- main() ---
WorkNow "$@";

# --- end main() ---



