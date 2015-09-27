
get_new_firebase_name() {
  echo "`shuf -n 2 share/adjectives | tr '\n' '-'`""`shuf -n 1 share/nouns`"
}

get_firebase_admin_token() {

  local email="${1-}"
  local password="${2-}"
  local TMPDIR=${TMPDIR:-/tmp}
  local tmpfile=`mktemp -t firebase.output.XXXX`

  curl -sS -G "https://admin.firebase.com/account/login" \
    --data-urlencode "email=$email" \
    --data-urlencode "password=$password" > $tmpfile

  local error=`$JQ -rM .error.code? $tmpfile`

  if [ "$error" == "null" ]; then
    $JQ -rM .adminToken $tmpfile
    rm $tmpfile
    return 0
  else
    echoerr "Invalid email or password supplied for \"$email\"."
    echoerr "Please check the values of \$FIREBASE_ADMIN_USER and \$FIREBASE_ADMIN_PASS."
    return 1
  fi

}

create_firebase() {

  local admin_token="${1-}"
  local firebase_name="${2-}"
  local TMPDIR=${TMPDIR:-/tmp}
  local tmpfile=`mktemp -t firebase.output.XXXX`

  curl -sS "https://admin.firebase.com/firebase/$firebase_name" \
    --data-urlencode "token=$admin_token" \
    --data-urlencode "appName=$firebase_name" > $tmpfile

  local error=`$JQ -rM .error.code? $tmpfile`

  if [ "$error" = "LIMITS_EXCEEDED" ]; then
    echoerr "You have created too many Firebases with this admin token."
    echoerr "Please remove other Firebases and try again."
    return 1
  else
    echo "$firebase_name.firebaseio.com"
    return 0
  fi

}

remove_firebase() {

  local admin_token="${1-}"
  local firebase_name="${2-}"
  local TMPDIR=${TMPDIR:-/tmp}
  local tmpfile=`mktemp -t firebase.output.XXXX`

  curl -sS "https://admin.firebase.com/firebase/$firebase_name" \
    --data-urlencode "token=$admin_token" \
    --data-urlencode "namespace=$firebase_name" \
    --data-urlencode "_method=DELETE" \
    > $tmpfile

  return 0

}

get_firebase_custom_auth_token() {

  local personal_token="${1-}"
  local firebase_name="${2-}"
  local TMPDIR=${TMPDIR:-/tmp}
  local tmpfile=`mktemp -t firebase.output.XXXX`

  curl -sS -G "https://$firebase_name.firebaseio.com/.settings/secrets.json" \
    --data-urlencode "auth=$personal_token" > $tmpfile

  local error=`$JQ -rM .error\? $tmpfile`

  if [ "$error" = "Could not parse auth token." ]; then
    echoerr "You supplied an incorrect or invalid personal token."
    echoerr "Please check the auth token and try again."
    return 1
  elif [ "$error" = "404 Not Found" ]; then
    echoerr "No such Firebase \"$firebase_name\"."
    echoerr "Please check the name of the Firebase and try again."
    return 3
  else
    $JQ -rM .[0] $tmpfile
    rm $tmpfile
    return 0
  fi

}

get_firebase_personal_token() {

  local admin_token="${1-}"
  local firebase_name="${2-}"
  local TMPDIR=${TMPDIR:-/tmp}
  local tmpfile=`mktemp -t firebase.output.XXXX`

  curl -sS -G "https://admin.firebase.com/firebase/$firebase_name/token" \
    --data-urlencode "token=$admin_token" \
    --data-urlencode "namespace=$firebase_name" > $tmpfile

  local error=`$JQ -rM .error.code $tmpfile`

  if [ "$error" = "AUTHENTICATION_REQUIRED" ]; then
    echoerr "You supplied an incorrect or invalid administrative token."
    echoerr "Please check the administrative token and try again."
    return 1
  elif [ "$error" = "INVALID_FIREBASE" ]; then
    echoerr "No such Firebase \"$firebase_name\"."
    echoerr "Please check the name of the Firebase and try again."
    return 3
  else
    $JQ -rM .personalToken $tmpfile
    rm $tmpfile
    return 0
  fi

}

set_firebase_auth_config() {

  local admin_token="${1-}"
  local firebase_name="${2-}"
  local auth_config_file="${3-}"
  local TMPDIR=${TMPDIR:-/tmp}
  local tmpfile=`mktemp -t firebase.output.XXXX`

  curl -sS "https://admin.firebase.com/firebase/$firebase_name/authConfig" \
    --data-urlencode token="$admin_token" \
    --data-urlencode authConfig="$(cat $auth_config_file)" \
    --data-urlencode _method=PUT > $tmpfile

  local error=`$JQ -rM .error?.message? $tmpfile`
  if [ "$error" != "null" ]; then
    echoerr "Error restoring auth config: $error"
    return 1
  else
    return 0
  fi

}
