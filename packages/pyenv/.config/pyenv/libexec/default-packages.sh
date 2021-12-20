#!/usr/bin/env sh
# This is taken from https://github.com/jawshooah/pyenv-default-packages
# which has the following LICENSE:
# Copyright (c) 2015 Joshua Hagins

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

install_default_packages() {
  # Only install default packages after successfully installing Python.
  [ "$STATUS" = "0" ] || return 0

  local installed_version requirements_file args

  installed_version=$1

  requirements_file=${GBP_HOME}/.config/pyenv/default_packages

  if [ -f "$requirements_file" ]; then
    args=( -r "$requirements_file" )

    # Invoke `pip install` in the just-installed Python.
    PYENV_VERSION="$installed_version" pyenv-exec pip install "${args[@]}" || {
      echo "pyenv: error installing packages from  \`$requirements_file'"
    } >&2
  fi
}
