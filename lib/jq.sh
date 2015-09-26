get_os() {
  uname | tr A-Z a-z
}

os=$(get_os)
export JQ="${BP_DIR}/vendor/jq-${os}"
