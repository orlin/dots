# helper functions for install scripts

# NOTE: for a current Ubuntu this is automatically so, however...
# TODO: maybe add $HOLY_SNAP_ON because using snap may be unwanted by some
# though this logic may change further with use of other operating systems
snapOn() {
  [ -x "$(command -v snap)" ] && { true; return; } || { false; return; }
}

# NOTE: same as the above, or worse, read these criticisms:
# https://flatkill.org/
# https://news.ycombinator.com/item?id=18180017
flatpakOn() {
  [ -x "$(command -v flatpak)" ] && { true; return; } || { false; return; }
}

# report when something goes wrong
noInstall() {
  >&2 echo "Fail: $(basename $0) did not install $1"
  status=1 # if using global $status then less code needed on the calling side
  return 1
}