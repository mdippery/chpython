CHPYTHON_VERSION='0.1.0'
PYTHONS=()

[ -d "${HOME}/.pythons" ] && PYTHONS+=("${HOME}/.pythons"/*)

function chpython_reset {
  [ -z "$CHPYTHON_ROOT" ] && return
  PATH=${PATH//:$CHPYTHON_ROOT\/bin:/:}
  type python
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
      echo "Exec'ing with Python version: $1"
      ;;
    system)
      chpython_reset
      ;;
    *)
      echo 'TODO: Set version...'
      ;;
  esac
}
