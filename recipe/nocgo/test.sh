#!/usr/bin/env bash
set -euf

# Test we are running GO under $CONDA_PREFIX
test "$(which go)" == "${CONDA_PREFIX}/bin/go"

# Ensure CGO_ENABLED=0, and compilers point to /dev/null
test "$(go env CGO_ENABLED)" == 0
test "$(go env CC)" == "/dev/null"
test "$(go env CXX)" == "/dev/null"
export FC=false

# Print diagnostics
go env

# Run go's built-in test
case $(uname -s) in
  Darwin)
    # Expect PASS
    # Expect PASS when run independently
    go tool dist test -v -k -no-rebuild -run='!^net/http|runtime|time$|os|cmd|internal'
    # Occasionally FAILS
    go tool dist test -v -k -no-rebuild -run='^net/http|runtime$|internal|time$|cmd|os' || true
    # Expect FAIL
    ;;
  Linux)
    # Fix issue where go tests find a .git/config file in the
    # feedstock root.
    # c.f.: https://github.com/conda-forge/go-feedstock/pull/75#issuecomment-612568766
    pushd $GOROOT; git init; git add --all .; popd
    
    # Expect PASS
    go tool dist test -v -k -no-rebuild -run='!testsanitizers|runtime|cmd|debug|crypto/internal/fips140test'
    # Occasionally FAILS
    go tool dist test -v -k -no-rebuild -run='^crypto/internal/fips140test|runtime$|debug|cmd' || true
    ;;
esac
