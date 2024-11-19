#!/usr/bin/env bash
set -eufx

# Test we are running GO under $CONDA_PREFIX
test "$(which go)" == "${CONDA_PREFIX}/bin/go"


# Ensure CGO_ENABLED=1
test "$(go env CGO_ENABLED)" == 1


# Print diagnostics
go env

# Ensure runtime/cgo is not stale.
# This will be assumed as stale as we have changed the value of CC since the build.
export CC=$(basename $CC)
go build -x runtime/cgo

# Run go's built-in test
case $(uname -s) in
  Darwin)
    if [[ $(uname -m) != arm64 ]]; then
        export CONDA_BUILD_SYSROOT=/opt/MacOSX10.14.sdk
        # Use -k (keep going) because nocgo tests can "panic: test timed out after 10m0s" on osx-64
        go tool dist test -k -v -no-rebuild -run='!^go_test:net/http|go_test:runtime|go_test:time$'
    else
        # Expect PASS
        go tool dist test -v -no-rebuild -run='!^go_test:net/http|go_test:runtime|go_test:time$'
    fi
    # Expect PASS when run independently
    go tool dist test -v -no-rebuild -run='!^go_test:net/http|go_test:runtime|go_test:time$' || true
    # Occasionally FAILS
    go tool dist test -v -no-rebuild -run='^go_test:net/http$' || true
    go tool dist test -v -no-rebuild -run='^go_test:runtime$' || true
    go tool dist test -v -no-rebuild -run='^go_test:time$' || true
    # Expect FAIL
    ;;
  Linux)
    # Fix issue where go tests find a .git/config file in the
    # feedstock root.
    # c.f.: https://github.com/conda-forge/go-feedstock/pull/75#issuecomment-612568766
    pushd $GOROOT; git init; git add --all .; popd

    echo "current architecture is: ${ARCH}"
    case $ARCH in
      ppc64le)
        # Expect PASS
        go tool dist test -v -no-rebuild -run='!^go_test:runtime$' || true
        # Occasionally FAILS
        go tool dist test -v -no-rebuild -run='^go_test:runtime$' || true
        # Expect FAIL
        ;;
      *)
        # Expect PASS
        go tool dist test -v -no-rebuild -run='!testsanitizers' || true
        ;;
    esac
    ;;
esac
