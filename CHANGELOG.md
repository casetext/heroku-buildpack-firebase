# Firebase Buildpack Changelog

## v4 (2015-10-12)

- Fixed a strange bug with credentials.

## v3 (2015-10-12)

- Properly restore the old Firebase data when in the cache.

## v2 (2015-09-28)

- Send Firebase environment variables to `$BP_DIR/export` for other buildpacks.

## v1 (2015-09-27)

Initial release, based on [heroku-buildpack-nodejs](https://github.com/heroku/heroku-buildpack-nodejs).
- Use jq 1.5 rather than 1.4.
- Access Firebase APIs using cURL.
- Look Ma, no Node required!
