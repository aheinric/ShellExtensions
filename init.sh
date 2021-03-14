SHELL_EXT_DIR="$HOME/ShellExtensions"
SHELL_EXT_RES="$SHELL_EXT_DIR/resources"

for m in $(find $SHELL_EXT_DIR -maxdepth 1 -type f -iname 'module*.sh' | sort); do
  source $m
done

printusage() {
  echo "helpme: Print help for shell extension script macros."
  echo "  usage: helpme [-h] [module]"
  echo "  options:"
  echo "    -h, --help: Print this usage message."
  echo "  Available Modules:"
  local m
  for m in $(find $SHELL_EXT_DIR -maxdepth 1 -type f -iname 'module*.sh' | sort); do
    echo "    $(basename $m)"
  done
  return 0
}

printhelp() {
  # Check if a module is specified.
  if [[ ! -f $1 ]]; then
    errecho "'$1' is not a shell extension module."
    return 1
  fi

  # Print doc comments from the file.
  echo -n "$(basename -- $1): "
  sed -n '/^##.*/p' $1 | sed 's/^###/   /' | sed 's/^##//'

  return 0
}

helpme() {
  if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    printusage
  elif [ "$1" != "" ]; then
    printhelp "$SHELL_EXT_DIR/$1"
  else
    local m
    for m in $(find $SHELL_EXT_DIR -maxdepth 1 -type f -iname 'module*.sh' | sort); do
      printhelp $m
    done
  fi
  return 0
}
