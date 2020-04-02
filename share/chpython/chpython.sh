CHPYTHON_VERSION='0.1.0.dev'
PYTHONS=()

for dir in "$PREFIX/opt/pythons" "$HOME/.pythons"; do
	[[ -d "$dir" && -n "$(ls -A "$dir")" ]] && PYTHONS+=("$dir"/*)
done
unset dir

function chpython_reset() {
  [ -z "$CHPYTHON_ROOT" ] && return

  PATH=":$PATH:"; PATH=${PATH//:$CHPYTHON_ROOT\/bin:/:}
  PATH="${PATH#:}"; PATH="${PATH%:}"
  unset CHPYTHON_ROOT
  hash -r
}


function _chpython_use() {
  if [[ ! -x "$1/bin/python" ]]; then
    echo "chpython: $1/bin/python is not executable" >&2
    return 1
  fi

  [[ -n "$CHPYTHON_ROOT" ]] && chpython_reset

  export CHPYTHON_ROOT="$1"
  export PATH="${CHPYTHON_ROOT}/bin:${PATH}"
  local python_version
  if [[ -e "$1/bin/python3" ]]; then
    PYTHON_VERSION="$($1/bin/python --version)"
  else
    PYTHON_VERSION="$($1/bin/python --version 2>&1 | awk '{print $2}')"
  fi
  hash -r
}


function chpython() {
  case "$1" in
    -h|--help)
      cat <<EOS
Usage:
  chpython [PYTHON|VERSION|system]
EOS
      ;;
    -V|--version)
      echo "chpython $CHPYTHON_VERSION"
      ;;
    system) chpython_reset ;;
    '')
      local dir python
      for dir in "${PYTHONS[@]}"; do
        dir="${dir%%/}"; python="${dir##*/}"
        if [[ "$dir" == "$CHPYTHON_ROOT" ]]; then
          echo " * ${python}"
        else
          echo "   ${python}"
        fi
      done
      ;;
    *)
      local dir python match
      for dir in "${PYTHONS[@]}"; do
        dir="${dir%%/}"; python="${dir##*/}"
        case "$python" in
          "$1")
            # Match using 3-part version number, e.g. `chruby 2.7.10`
            match="$dir" && break
            ;;
          "$1"*)
            # Match best using 2-part version number, e.g., `chpython 2.7`
            match="$dir"
            ;;
        esac
      done
      if [ -z "$match" ]; then
        echo "chpython: unknown Python: $1" >&2
        return 1
      fi

      shift
      _chpython_use "$match"
      ;;
  esac
}
