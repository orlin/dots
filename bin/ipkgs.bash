# Sourced by `ipkgs`, this provides helpers.

# verify it's bash version >= 4
# for associative arrays, in use by ipkgs
if [ ${BASH_VERSION%%[^0-9]*} -lt 4 ]; then
  echo "Bash must be version 4 or greater."
  echo "Currently it's: '${BASH_VERSION}'."
  exit 1
fi

usage() {
  echo "Usage: $(basename $0) [-p] file(s)"
}

options=()
arguments=()

for arg in "$@"; do
  if [ "${arg:0:1}" = "-" ]; then
    if [ "${arg:1:1}" = "-" ]; then
      options[${#options[*]}]="${arg:2}"
    else
      index=1
      while option="${arg:$index:1}"; do
        [ -n "$option" ] || break
        options[${#options[*]}]="$option"
        let index+=1
      done
    fi
  else
    arguments[${#arguments[*]}]="$arg"
  fi
done

if [ "${#arguments[@]}" -eq 0 ]; then
  usage >&2
  exit 1
fi

unset paths

for option in "${options[@]}"; do
  case "$option" in
  "p" | "paths" )
    paths="1"
    ;;
  * )
    usage >&2
    exit 1
    ;;
  esac
done

declare where # a path prefix
if [ -n "$paths" ]; then
  # the --paths flag, meaning...
  # valid paths provided as part of the files - either relative or absolute
  where='' # no need to adjust location
else
  # less typing - uses env var or the relative default
  echo Using \$IPKGS_PATH = \'${IPKGS_PATH:=$(realpath "$(dirname $0)/../install/packages")}\'.
  where="$IPKGS_PATH/"
fi

# special cases when command isn't the filename
# if a file isn't in this list, the $command is taken up until the first dash
declare -A special=(
  ["apt"]="apt-get"
  ["apt-get"]="apt-get" # just for example, or the '-get' would get truncated
  ["brew-cask"]="brew cask"
)

# some commands can only run on certain operating systems
# these are confirmed by filename
system=`uname -s`
declare -A syscheck=(
  ["apm-darwin"]="Darwin"
  ["apt"]="Linux" # could check for ubuntu or debian, yet presence is enough
  ["brew"]="Darwin"
  ["brew-cask"]="Darwin"
)

# it's `$pm install $package` - except for the following special cases
declare -A install=(
  ["npm"]="npm i -g"
)
