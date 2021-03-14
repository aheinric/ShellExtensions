## Python venv capabilities

export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
# Support virtualenvwrapper
source virtualenvwrapper.sh

# The following are helpers for using local venv dirs,
# instead of the global virtualenvwrapper ecosystem.

### mkvenv [name]: Helper for making a local venv.
###     - arg name: an optional display name.  If not provided, defaults to the current directory name.
###     - venv gets stored in PWD/.venv
mkvenv() {
  #Check that python3 is available
  py3=$(which python3)
  if [[ "$py3" == "" ]]; then
    errecho "Could not find python3."
    return 1
  fi

  # Check that ./.venv is available
  if [[ -d ".venv" ]]; then
    errecho "Directory '.venv' exists."
    return 1
  elif [[ -f ".venv" ]]; then
    errecho "'.venv' exists as a file."
    return 1
  fi

  # Check if we want the default name.
  if [ "$1" == "" ]; then
    name=$(basename $(pwd))
  else
    name="$1"
  fi

  # Make the new virtualenv.
  virtualenv -p "$py3" --prompt="($name) " ".venv" || return 1
  envon || return 1
  return 0
}

### envon: Helper for activating a local venv created with mkvenv
###     - To leave the venv, execute "deactivate" as normal.
envon() {
  # Check if we have a local venv
  if [[ ! -d ".venv" ]]; then
    errecho "No local '.venv'"
    return 1
  elif [[ ! -f ".venv/bin/activate" ]]; then
    errecho "No 'activate' script"
    return 1
  fi
  source ./.venv/bin/activate || return 1
  return 0
}
