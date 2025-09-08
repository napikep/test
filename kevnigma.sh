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


