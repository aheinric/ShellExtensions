## Universal shell helper functions.

### errecho msg: Universally helpful helper for echoing to stderr.
###    - arg msg: message to be echoed.
errecho() {
  echo -e "$1" 1>&2
}

### fail msg: Universally helpful helper for reporting fatal errors in scripts.
###    - arg msg: failure message.
###    - Outcome: script prints 'msg' and exits with return code 1.  Useful for unrecoverable errors.
###    - NOTE: Don't use this in an interactive terminal; it will kill the terminal.
fail() {
  errecho "$1"
  exit 1
}

### argdir [dir]: Handle optional cwd arguments.
###    - arg dir: Optional directory argument.
###    - Outcome: working dir stored in $cwd.
###        - dir, if it's a valid directory path.
###        - `pwd`, if dir is empty.
###    - Fail if dir is specified, but not a valid directory path.
argdir() {
  if [ "$1" != "" ]; then
    if [ "$1" == "$cwd" ]; then
      # argument 'dir' equals existing $cwd.  No-op.
      return 0
    else
      # argument 'dir' was provided.  Use 'dir' as $cwd
      cwd="$1"
    fi
  else
    # No argument, or $cwd was blank.  Use `pwd` as $cwd
    cwd=$(pwd)
  fi
 
  if [[ ! -d "$cwd" ]]; then
    # $cwd is an invalid path.
    cwd=''
    errecho "Error(argdir): '$1' is not a directory"
    return 1
  fi
  return 0
}
