## Add custom vim commands.

### update_vimrc: Update your local .vimrc file
###     - Regenerates local vimextend.vim file.
###     - Generates ~/.vimrc if it doesn't exist.
###     - Adds a line to ~/.vimrc to import vimextend.vim 
###     - Note: Runs every time this module gets loaded; rerun if you change vim extensions.
update_vimrc() {
  update_vimextend || return 1
  local vimrc_path="$HOME/.vimrc"
  local src_cmd="source $SHELL_EXT_DIR/resources/vimextend.vim"
  if [[ -f "$vimrc_path" ]]; then
    # Check if we already have a suitably-configured vimrc file.
    grep -F "$src_cmd" $vimrc_path > /dev/null && return 0
  fi

  # If not, echo the 
  echo "$src_cmd" >> "$vimrc_path" || (errecho "Failed to append to $vimrc_path."; return 1)
  return 0
}

update_vimextend() {
  local vimextend_path="$SHELL_EXT_DIR/resources/vimextend.vim"
  local this_path="$SHELL_EXT_DIR/module_vimextend.sh"
  local extension_comment='###     -'
  local find_help_pattern="s/^\"\(.*\)/\1/p"
  local delete_help_pattern="/^$extension_comment .*\.vim:/d"
  # Erase pre-existing root module.
  if [[ -f $vimextend_path ]]; then
    rm $vimextend_path || return 1
  fi

  # Erase preexisting vimextend help messages in this file.
  sed -i.bak "$delete_help_pattern" $this_path || return 1
  rm -f "$this_path.bak"

  # Make sure vimextend.vim exists
  touch $vimextend_path

  # Search resources for vimextend modules.
  for m in $(find "$SHELL_EXT_DIR/resources/vimextend" -type f -name '*.vim'); do
    echo "source $m" >> $vimextend_path || (errecho "Failed to add plugin $m to $vimextend_path"; return 1)
    sed -n "$find_help_pattern" $m | xargs -I @ echo "$extension_comment $(basename $m): @" >> $this_path
  done
  return 0
}

# Update .vimrc if needed.
update_vimrc
# Auto-populated help.  DO NOT EDIT!
### Specific Extensions:
###     - highlight.vim: Add syntax highlighting
###     - macros.vim: Ctl + _: Clear the search buffer
###     - vsp.vim: This fixes a problem with vsp on macs. Forget what.
###     - indent.vim: Add automatic indentation.
