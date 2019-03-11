#!/bin/bash

. .test/assert/assert.sh

# Sourcing the following files should return 0
# Note that .zshrc needs executable permissions for this
if [ ! -n "${GBP_TEST}" ]; then
    assert_raises "./.zshrc" 0  # Turned-off for Travis becuase I couldn't figure-out how to install zsh adequately
fi

# ... they should also output nothing ...
# The version of the pure shell we are using generates
# 4 spurious carriage returns when run as a non-login shell
if [ ! -n "${GBP_TEST}" ]; then
    assert "./.zshrc 2>&1" "\n\n\n\n" # Turned-off for Travis becuase I couldn't figure-out how to install zsh adequately
fi

# end of test suite
assert_end zsh_config_tests
