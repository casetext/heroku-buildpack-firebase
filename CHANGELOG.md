# Firebase Buildpack Changelog

## v2 (2015-09-28)

- Send Firebase environment variables to `$BP_DIR/export` for other buildpacks.

## v1 (2015-09-27)

Initial release, based on [heroku-buildpack-nodejs](https://github.com/heroku/heroku-buildpack-nodejs).
- Use jq 1.5 rather than 1.4.
- Access Firebase APIs using cURL.
- Look Ma, no Node required!
