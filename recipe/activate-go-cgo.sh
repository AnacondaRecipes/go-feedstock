export CONDA_BACKUP_GOROOT="${GOROOT:-}"
export GOROOT="${CONDA_PREFIX}/go"

export CONDA_BACKUP_CGO_ENABLED="${CGO_ENABLED:-}"
export CGO_ENABLED=1

export CONDA_BACKUP_CGO_CFLAGS="${CGO_CFLAGS:-}"
export CGO_CFLAGS="$CFLAGS"

export CONDA_BACKUP_CGO_CPPFLAGS="${CGO_CPPFLAGS:-}"
export CGO_CPPFLAGS="$CPPFLAGS"

export CONDA_BACKUP_CGO_CXXFLAGS="${CGO_CXXFLAGS:-}"
export CGO_CXXFLAGS="${CXXFLAGS:-}"

export CONDA_BACKUP_CGO_FFLAGS="${CGO_FFLAGS:-}"
export CGO_FFLAGS="${FFLAGS:-}"

export CONDA_BACKUP_CGO_LDFLAGS="${CGO_LDFLAGS:-}"
export CGO_LDFLAGS="$LDFLAGS"
