## Extend path with files that OS X doesn't know about.

# First, make sure we don't clutter PATH if you keep sourcing .profile.
# Do this by saving off the path when we first start this session.
if [ "$OLD_PATH" == "" ]; then
  export OLD_PATH=$PATH
else
  export PATH=$OLD_PATH
fi

# Actually extend the path.
# The only one for now is adding python 3.
export PATH=/Users/aheinricher/Library/Python/3.7/bin:$PATH
