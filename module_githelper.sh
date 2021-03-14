## Helper functions for managing git.

### isrepo [dir]: Check if a directory is a repository.
###     - dir: Optional directory to check.  Defaults to CWD.
###     - Output by return value only:
###         - 0: Pass
###         - 1: Fail
###         - 2: Error
isrepo() {
  argdir $1 || return 1
  git -C "$cwd" branch &> /dev/null && return 0 || return 1
}

### reporoot [dir]: Find the root directory of a repository.
###     - arg dir: Optional working dir.  Defaults to CWD.
###     - Output is stored in $out
###     - Fails if 'dir' is not a valid directory.
reporoot() {
  argdir $1 || return 1
  local ret=0
  pushd $cwd > /dev/null || return 1
  isrepo || ( errecho "Error(reporoot): '$cwd' is not a git repository."; local ret=1 )
  git rev-parse --show-toplevel > /dev/null && out=$(git rev-parse --show-toplevel) || local ret=1
  popd > /dev/null || return 1
  return $ret
}

### mkgitignore language [dir]: Add a project-appropriate gitignore file.
mkgitignore() {
  argdir $2 || return 1
  local lang=$(echo "$1" | tr '[:upper:]' '[:lower:]')
  
  if [ "$lang" == "c" ]; then
    local srcpath="$SHELL_EXT_RES/pyhelper/gitignore_c"
  elif [ "$lang" == "python" ]; then
    local srcpath="$SHELL_EXT_RES/pyhelper/gitignore_python"
  else
    errecho "Error(mkgitignore): Unknown language: '$lang'"
    return 1
  fi
  reporoot $cwd && local destpath="out/.gitignore" || return 1

  cp $srcpath $destpath || return 1
  return 0
}

mkrepo() {
  ardgir $1 || return 1
  isrepo $cwd && (errecho "Error(mkrepo): You're already in a repo."; return 1)
  return 1
}
