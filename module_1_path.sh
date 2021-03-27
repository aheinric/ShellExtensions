## Extend path with custom directories.

### You can specify custom directories in 'resources/paths.cfg':
###    - Each line should contain one directory.
###    - A line can reference environment variables; e.g.: '$HOME/local/bin'
###    - A '#' defines a comment; all whitespace before the '#' and the rest of the line after it are ignored.

# Avoid cluttering path if .profile gets sourced more than once.
# TODO: This may have some downsides.
#       If $PATH gets updated, the saved copy won't reflect that.
if [ "$SHELL_EXT_OLD_PATH" == "" ]; then
  # If we don't have a saved "original" path, save it.
  export SHELL_EXT_OLD_PATH=$PATH
else
  # Otherwise, restore the path from the saved copy before editing.
  export PATH=$SHELL_EXT_OLD_PATH
fi

# Define the PATH separator character.
# TODO: uncomment the appropriate line for your plaform.
ps=':'  # Linux, MacOS X, and similar.
#ps=';' # Windows, mingw, cygwin, and similar.  Not sure about the Windows 10 linux subsystem.

# Extend PATH with entries from a resource file.
# This keeps this file from getting clobbered with user-specific configuration.
path_cfg="$SHELL_EXT_RES/paths.cfg"

if [[ ! -f "$path_cfg" ]]; then
  echo "# Put extra PATH entires in here, one per line."
fi

while read -r l; do
  # Remove comments
  l=$(echo "$l" | sed -E 's/\s*#.*//')
  if [ "$l" == '' ]; then
    # If the whole line was a comment, ditch it.
    continue
  fi

  # Expand environment variables.
  l=$(expandenv "$l")

  export PATH="$l$ps$PATH"
  
done < "$path_cfg"
