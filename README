# Extension framework for your shell.

Tired of rewriting your profile configurations?
Want somewhere to stash that neat bash trick you learned?

ShellExtensions gives you a pluggable framework
for extending your shell environment with
a modularized group of setup scripts.

## How to use

### Installation

This is intended to replace a user's `.profile`, `.bashrc`, `.vimrc`, and similar.
Back up any existing scripts, and blank the originals.

Add the following line to `~/.profile` (assuming you cloned to ~/ShellExtensions):

  source ~/ShellExtensions/init.sh

That's it!

### Making Changes

If you modify any of the scripts, you will need to update your environment.

If you overwrote an exported command, you can update by running `source ~/.profile`.

If you want to remove something, the easiest way is to exit your shell session and open a new one.

### Getting Help

`man` pages are a disaster to write, so ShellExtension
offers a quick-and-dirty way to document extension scripts:

- Any line beginning with `##` (no leading space allowed) is recognized as documentation.
- `##` indicates a file-level comment.
- `###` indicates a function-level comment.

The framework exports the command `helpme` to access this information:

  helpme [-h] [module_file]

- If the first argument is `-h` or `--help`, the output will be the usage of `helpme`.
- If the first argument is a module file name, the output will be all doc comments for that file.
- If you pass no arguments, the output will be the doc comments for all modules.

## How it works

ShellExtension's job is to source script modules.
A module is a script in this directory named `module.+\.sh`

The script `init.sh` scans this directory for files
with that name pattern, and loads any that it finds.

The modules can be as complex as you want; it's all just bash.

### Module Load Order and Dependencies

Modules are loaded alphabetically by file name.
You can impose a load order by adding a number to the module name 
right after the `module` prefix; I provide a couple examples by default.

**NOTE:** Different systems may sort multi-digit numbers differently.
Test before you rely on this.

Modules currently have no way to define dependencies.
However, anything defined in any module is accessible in all other modules
once initialization is complete.  Thus, you don't need to worry about
load order for functions; everything will be present by the time the user calls them.

If you want to reference functionality from another module during initialization,
I recommend making use of load ordering.

### Collision Management

None; it's up to you to make sure your modules don't clobber each other.
