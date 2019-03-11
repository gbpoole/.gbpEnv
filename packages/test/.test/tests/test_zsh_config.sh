#!/bin/bash

. .test/assert/assert.sh

# Sourcing the following files should return 0
# Note that .zshrc needs executable permissions for this
assert_raises "./.zshrc" 0

# ... they should also output nothing ...
# The version of the pure shell we are using generates
# 4 spurious carriage returns when run as a non-login shell
#assert "./.zshrc 2>&1" ""

# end of test suite
assert_end zsh_config_tests
