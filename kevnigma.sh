check_variables() {
  if [ -z "${hostname}" ]; then
      abort "-- 'hostname' variable not found. Create a host first.";
  elif [ -z "${username}" ] || [ -z "${password}" ]; then
      abort "-- 'username' or 'password' variable not found. Create a user and set a password first.";
  else
      echo "-- Checked variables!";
  fi
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
  sudo hostnamectl set-hostname "${hostname}"; # Creation of host
  sudo useradd -m "${username}"; # Creation of user
  sudo adduser "${username}" sudo; # Add user to sudo group
  echo "${username}:${password}" | sudo chpasswd; # Set password of user
  sudo sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd; # Change default shell from sh to bash
  echo "-- Host, User created and configured having hostname '${hostname}', username '${username}', and password '${password}'.";
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
    check_variables "$@";
    create_host_and_user;
    echo "-----------------------------------------";
    echo "-- Please Be Patient for installation.";
    echo "-----------------------------------------";
    sudo apt-get update;
    echo "-----------------------------------------";
    echo "-- Succesfully Script Remake By Kevnigma.";
    echo "-----------------------------------------";
    OpenEnvironment;
}

# --- main() ---
WorkNow "$@";
# --- end main() ---