####
#### The following few helper functions have been ~copied~
#### shamelessly stolen from `pass`. Mostly secure tmp creation
#### and ensuring we leave no garbage behind.
####
#
PROGRAM=$(basename $0)

die() {
  echo "$@" >&2
  exit 1
}

yesno() {
  [[ -t 0 ]] || return 0
  local response
  read -r -p "$1 [y/N] " response
  [[ $response == [yY] ]] || exit 1
}

check_sneaky_paths() {
  local path
  for path in "$@"; do
    [[ $path =~ /\.\.$ || $path =~ ^\.\./ || $path =~ /\.\./ || $path =~ ^\.\.$ ]] \
      && die "Error: You've attempted to pass a sneaky path to $PROGRAM. Go home."
  done && true
}

tmpdir() {
  set +u
  [[ -n $SECURE_TMPDIR ]] && return
  local warn=1
  [[ $1 == "nowarn" ]] && warn=0
  local template="$PROGRAM.XXXXXXXXXXXXX"
  if [[ -d /dev/shm && -w /dev/shm && -x /dev/shm ]]; then
    SECURE_TMPDIR="$(mktemp -d "/dev/shm/$template")"
    remove_tmpfile() {
      rm -rf "$SECURE_TMPDIR"
    }
    trap remove_tmpfile EXIT
  else
    SECURE_TMPDIR="$(mktemp -d "${TMPDIR:-/tmp}/$template")"
    shred_tmpfile() {
      find "$SECURE_TMPDIR" -type f -exec shred -f -z {} +
      rm -rf "$SECURE_TMPDIR"
    }
    trap shred_tmpfile EXIT
  fi
}

cmd_edit() {
  [[ $# -ne 1 ]] && die "Usage: $PROGRAM pass-name"

  local path="${1%/}"
  # check_sneaky_paths "$path"

  tmpdir #Defines $SECURE_TMPDIR
  local tmp_file="$(mktemp -u "$SECURE_TMPDIR/XXXXXX")-${path//\//-}.txt"

  if [[ -f $path ]]; then
    age-decrypt "$path" > "$tmp_file" || exit 1
  else
    die "Can't find $path"
  fi

  ${EDITOR:-vi} "$tmp_file"
  [[ -f $tmp_file ]] || die "New password not saved."
  age-decrypt "$path" | diff - "$tmp_file" &>/dev/null && die "Password unchanged."

  tmpencrypted="$tmp_file.tmp"
  age-encrypt "$tmp_file" > "$tmpencrypted"
  mv "$tmpencrypted" "$path"
}

if [ ! $(which shred) ] || [ ! $(which age) ]; then
  die "Dependencies are not installed"
fi
