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
      echo 'usage: chpython [PYTHON|VERSION|system]'
      ;;
    -V|--version)
      echo "chpython $CHPYTHON_VERSION"
      ;;
    system)
      chpython_reset
      ;;
    *)
      echo 'TODO: Set version...'
      ;;
  esac
}
