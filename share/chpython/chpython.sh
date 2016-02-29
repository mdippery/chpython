CHPYTHON_VERSION='0.1.0.dev'
PYTHONS=()

[ -d "${HOME}/.pythons" ] && PYTHONS+=("${HOME}/.pythons"/*)

function _chpython_exec {
  local python
  python=$1
  shift
  # TODO: Clear path so invoking `chpython 3.5 python -V` when
  # $CHPYTHON_VERSION is set to a 2.x Python gives a command not
  # found error instead of running $CHPYTHON_VERSION/bin/python.
  env PATH="$python/bin:$PATH" $*
}

function _chpython_reset {
  [ -z "$CHPYTHON_ROOT" ] && return
  PATH=":$PATH:"
  PATH=${PATH//:$CHPYTHON_ROOT\/bin:/:}
  PATH=${PATH#:}; PATH=${PATH%:}
  unset CHPYTHON_ROOT
  hash -r
  type python || type python3
}

function _chpython_select {
  local dir python match
  for dir in ${PYTHONS[@]}; do
    dir=${dir%%/}
    python=${dir##*/}
    case "$python" in
      "$1")
        # Match using 3-part version number, e.g. `chruby 2.7.10`
        match=$dir && break
        ;;
      "$1"*)
        # Match best using 2-part version number, e.g., `chpython 2.7`
        match=$dir
        ;;
    esac
  done
  echo "$match"
}

function _chpython_use {
  if [[ ! -x "$1/bin/python" && ! -x "$1/bin/python3" ]]; then
    echo "chpython: neither $1/bin/python nor $1/bin/python3 are executable" >&2
    return 1
  fi

  # TODO: Alias *3 stuff to base name, so, e.g., `python` can be called
  # instead of `python3`

  export CHPYTHON_ROOT=$1
  export PATH="${CHPYTHON_ROOT}/bin:${PATH}"
  hash -r
  type python || type python3
}

function chpython {
  case "$1" in
    -h|--help)
      cat <<EOS
Usage:
  chpython [PYTHON|VERSION|system]
  chpython exec [PYTHON|VERSION] args...
EOS
      ;;
    -V|--version)
      echo "chpython $CHPYTHON_VERSION"
      ;;
    exec)
      shift
      local match
      match=$(_chpython_select $1)
      if [ -z "$match" ]; then
        echo "chpython: unknown Python: $1" >&2
        return 1
      fi

      shift
      _chpython_exec $match $*
      ;;
    system)
      _chpython_reset
      ;;
    '')
      local dir python
      for dir in ${PYTHONS[@]}; do
        dir="${dir%%/}"
        python=${dir##*/}
        if [[ "$dir" == "$CHPYTHON_ROOT" ]]; then
          echo " * ${python}"
        else
          echo "   ${python}"
        fi
      done
      ;;
    *)
      local match
      match=$(_chpython_select $1)
      if [ -z "$match" ]; then
        echo "chpython: unknown Python: $1" >&2
        return 1
      fi

      shift
      _chpython_use $match $*
      ;;
  esac
}
