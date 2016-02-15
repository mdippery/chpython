CHPYTHON_VERSION='0.1.0'
PYTHONS=()

[ -d "${HOME}/.pythons" ] && PYTHONS+=("${HOME}/.pythons"/*)

function chpython {
  case "$1" in
    -h|--help)
      echo 'usage: chpython [PYTHON|VERSION|system]'
      ;;
    -V|--version)
      echo "chpython $CHPYTHON_VERSION"
      ;;
    system)
      echo 'TODO: Reset to system...'
      ;;
    *)
      echo 'TODO: Set version...'
      ;;
  esac
}
