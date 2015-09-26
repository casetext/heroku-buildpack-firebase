
export_env_dir() {
  local env_dir="$1"
  if [ -d "$env_dir" ]; then
    local whitelist_regex=${2:-''}
    local blacklist_regex=${3:-'^(PATH|GIT_DIR|CPATH|CPPATH|LD_PRELOAD|LIBRARY_PATH)$'}
    if [ -d "$env_dir" ]; then
      for e in $(ls $env_dir); do
        echo "$e" | grep -E "$whitelist_regex" | grep -qvE "$blacklist_regex" &&
        export "$e=$(cat $env_dir/$e)"
        :
      done
    fi
  fi
}

write_profile() {
  local build_dir="$1"
  local profile_dir=$build_dir/.profile.d
  local profile_file="$profile_dir/firebase.sh"
  mkdir -p $profile_dir
  cat <<EOF > $profile_file
[ -z \$FB_NAME ] && export FB_NAME=$FB_NAME
[ -z \$FIREBASE_URL ] && export FIREBASE_URL=$FIREBASE_URL
[ -z \$FIREBASE_AUTH_SECRET ] && export FIREBASE_AUTH_SECRET=${FIREBASE_AUTH_SECRET-}
EOF
}
