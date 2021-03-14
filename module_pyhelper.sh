## Helper commands for creating and manipulating python projects.

### mkproj: Create a python project.
###     - Copies boilerplate code.
###     - Configures setup.py with a package named after CWD.
mkpyproj() {
  argdir $1 || return 1
  local resource_dir="$SHELL_EXT_DIR/resources/pyhelper"
  local pkgname=$(basename "$cwd")
  local pkgdir="$cwd/$pkgname"
  
  # Create the package directory
  mkdir "$pkgdir" || return 1
  
  # Create and activate a virtualenv
  mkvenv
  envon

  # Create and configure setup.py
  cp "$resource_dir/setup.py" "$cwd/" || return 1
  sed -i.bak "s/PACKAGE_NAME/$pkgname/g" "$cwd/setup.py" || ( errecho "Failed to reconfigure setup.py"; return 1 )
  # Remember this bit; Mac OS X sed creates backup files.
  rm *.bak || return 1

  # Copy over the initial driver.
  cp "$resource_dir/__init__.py" "$pkgdir/" || return 1
  cp "$resource_dir/cli.py" "$pkgdir/" || return 1
  
  pysetup $cwd
  return $?
}

### pysetup: Shorthand for installing a python project.
###     - Only intended for use in a virtualenv.
pysetup() {
  argdir $1 || return 1

  if [[ ! -f "$cwd/setup.py" ]]; then
    errecho "'$cwd' doesn't contain a python project."
    return 1
  fi

  if [[ "$VIRTUAL_ENV" == "" ]]; then
    errecho "You're not in a venv.  Please get into one."
    return 1
  fi
  
  pushd $cwd > /dev/null || return 1
  python setup.py develop && local ret=0 || local ret=1
  popd > /dev/null || return 1
  return $ret
}

### pyrm: Shorthand for removing a python project
###     - Only intended for use in a virtual environment.
pyrm() {
  argdir $1 || return 1
  if [[ ! -f "$cwd/setup.py" ]]; then
    errecho "'$cwd' doesn't contain a python project."
    return 1
  elif [[ "$VIRTUAL_ENV" == "" ]]; then
    errecho "You're not in a venv.  Get into one."
    return 1
  fi
  
  pushd $cwd > /dev/null || return 1
  python setup.py develop -u && rm -rf *.egg-info && pyrm_ret=0 || pyrm_ret=1
  popd > /dev/null || return 1
  return $pyrm_ret
}
