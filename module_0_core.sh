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

### expandenv str [all]: Expand environment variables in a string.
###    - arg str:   String possibly containing expandable variables.
###    - arg all: Optional flag; if non-empty, also replace local shell variables.
###    - Outcome: Echoes expanded version of str to stdout.
###        - Looks for strings of the pattern $name.
###        - If 'name' matches a variable, replace '$name' with the variable's value.
###        - If 'name' does not match, do nothing.
###    - NOTE: The "easy" way to do this is $(eval "echo \"$str\"").
###        - As you can imagine, the easy way is a terrible idea.
###    - TODO: The code for getting the variable name/value pairs isn't perfect.
###        - It won't handle newlines or quoted strings correctly.
###        - This won't break the parser, but some variables may not appear as desired.
expandenv() {
  local str="$1"
  if [ "$2" == "" ]; then
    # If we did not specify 'all', only use environment variables.
    local var_cmd='printenv'
  else
    # Otherwise, use all currently-set variables.
    local var_cmd='eval (set -o posix ; set)'
  fi
  
  sed_cmd=""
  while read -r v; do
    # Variables are printed as "name=value"
    # If we see no equals, skip the line.
    echo "$v" | grep "=" > /dev/null || continue 

    # Extract the name/value pair from the line.
    local name=$(echo "$v" | sed -E 's#^([A-Za-z0-9_]+)[=].*#\1#')
    local value=$(echo "$v" | sed -E 's#^[A-Za-z0-9_]+[=](.*)#\1#')

    # Create a sed command to replace '$name' with 'value'
    local tmp_cmd="s#[\$]$name#$value#g"

    if [ "$sed_cmd" == '' ]; then
      # If our global sed command is empty, just drop in tmp_cmd.
      local sed_cmd="$tmp_cmd"
    else
      # Otherwise, join with ';'
      local sed_cmd="$sed_cmd; $tmp_cmd"
    fi 
  done< <($var_cmd)
  echo "$str" | sed -E "$sed_cmd"
}
