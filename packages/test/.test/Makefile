# This makefile deals with all CI processing of the .gbpEnv repository

.PHONY: test clean

# Set the KCov token
KCOV_TOKEN="093d2255-106c-40f4-b3f9-5056c7935cd1"

# This ensures that we use standard (what is used in interactive shells) version of echo.
ECHO = /bin/echo

# Set a flag alerting that we are running tests
GBPENV_TEST=1

# Determine what sort of environment we're in (eg. OSX or Linux)
# Set linux defaults
KCOV_DIR='.test/kcov-master'
KCOV_EXE=$(KCOV_DIR)'/build/src/kcov'
_MAC_BUILD=0
_TRAVIS_BUILD=0
ifdef TRAVIS_OS_NAME
    ifeq ($(TRAVIS_OS_NAME),'osx')
        KCOV_EXE=$(KCOV_DIR)'/build/src/Release/kcov'
        _MAC_BUILD=1
    endif
    _TRAVIS_BUILD=1
else
    ifeq ($(GBP_OS),Mac)
        KCOV_EXE=$(KCOV_DIR)'/build/src/Release/kcov'
        _MAC_BUILD=1
    endif
endif
export KCOV_EXE
export _MAC_BUILD
export _TRAVIS_BUILD

# Generate tests for the CI service
TEST_LIST=$(notdir $(wildcard .test/tests/*))
.PHONY: ${TEST_LIST} tests
${TEST_LIST}:
	.test/tests/$@
tests: ${TEST_LIST}
	@$(ECHO) tests processed 

# Generate coverage information for bash configuration
BASH_CONFIG_LIST = .bashrc .bashrc.system
.test/kcov.tgz:
	@$(ECHO) -n "Downloading kcov code..."
	@wget https://github.com/SimonKagstrom/kcov/archive/master.tar.gz -O .test/kcov.tgz
	@tar xfz .test/kcov.tgz -C .test
	@$(ECHO) "Done."
$(KCOV_EXE): .test/kcov.tgz
ifeq ($(_MAC_BUILD),1)
	@cd $(KCOV_DIR);mkdir build;cd build;cmake -G Xcode .. ;xcodebuild -configuration Release
else
	@cd $(KCOV_DIR);mkdir build;cd build;cmake .. ;make
endif
$(BASH_CONFIG_LIST): $(KCOV_EXE)
	@$(ECHO) -n "Generating coverage report for: "$@"..."
	@echo "#/bin/bash" > .test/$@.kcov.sh
	@chmod a+x .test/$@.kcov.sh
	@cat $@ >> .test/$@.kcov.sh
	@$(KCOV_EXE) .test/coverage .test/$@.kcov.sh
	@$(ECHO) "Done."
kcov_bash: $(BASH_CONFIG_LIST)

# Generate and upload all coverage information
kcov: kcov_bash
	@$(ECHO) -n "Finalizing Codecov integration..."
	@bash -c "bash <(curl -s https://codecov.io/bash) -t $(KCOV_TOKEN)"
	@$(ECHO) "Done."

# Clean-up
clean:
	@rm -rf .test/kcov.tgz $(KCOV_DIR) .test/coverage
	@rm -rf .test/*.kcov.sh .test/.*.kcov.sh
