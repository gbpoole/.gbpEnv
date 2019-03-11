#!/bin/bash

. .test/assert/assert.sh

# Sourcing the following files should return 0
# Note that .bashrc needs executable permissions for this
assert_raises "./.bashrc" 0

# ... they should also output nothing ...
assert "./.bashrc 2>&1" ""

# end of test suite
assert_end bash_config_tests
