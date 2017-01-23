# Abandoned

With the rollout of the new Firebase console, this buildpack [no longer works](https://github.com/casetext/heroku-buildpack-firebase/issues/1).  We do not have any plans to continue supporting this repo.

---

# Heroku Buildpack for Firebase

This is an unofficial buildpack to automatically provision Firebase instances for Heroku apps.

## Usage

1. Add this buildpack to an existing Heroku app:
  ```bash
  # "-i 1" inserts this buildpack as the first buildpack to run, so that your
  # Firebase is guaranteed to be available by the time your normal buildpack runs.
  $ heroku buildpacks:add -i 1 https://github.com/casetext/heroku-buildpack-firebase \
    --app <your-app-name>
  ```

2. Set the config vars `FIREBASE_ADMIN_USER` and `FIREBASE_ADMIN_PASS` to a valid
set of login credentials to Firebase.

3. Build your app as usual. When your buildpack runs, there will now be three
environment variables set:
  - `FB_NAME`: the randomly-chosen name of the Firebase, like `few-melodic-winter`
  - `FIREBASE_URL`: the hostname of the Firebase, like `few-melodic-winter.firebaseio.com`
  - `FIREBASE_AUTH_SECRET`: an authentication secret for the Firebase that you can
  use to generate JWTs of your own or just on its own as an administrative credential.

## Custom auth config

The auth configuration (OAuth via Facebook/etc., users and passwords, etc.) of
a Firebase cannot be changed without specialized tools.

If you would like to enable different authentication types for your new Firebase
(which is the reason you aren't using firebaseio-demo.com to begin with),
add a file named `firebase-config.json` to the root of your repo.

The default auth config looks like this. You can copy it out and change it as
you need.
```json
{
  "domains": [],
  "sessionLengthSeconds": 86400,
  "anonymous": {
    "enabled": false
  },
  "facebook": {
    "enabled": false,
    "key": "",
    "secret": ""
  },
  "github": {
    "enabled": false,
    "key": "",
    "secret": ""
  },
  "google": {
    "enabled": false,
    "key": "",
    "secret": ""
  },
  "password": {
    "enabled": false,
    "emails": {
      "password-reset": {
        "from": "@<YOUR_FIREBASE_NAME>.firebaseapp.com",
        "fromname": "",
        "replyto": "",
        "subject": "",
        "template": "Hello!\n\nIt looks like you've forgotten your password.\n\nUse the following temporary password within the next 24 hours to log in and update your account: %TOKEN%\n\nThanks!",
        "format": "plainText"
      }
    }
  },
  "twitter": {
    "enabled": false,
    "key": "",
    "secret": ""
  }
}
```

## About buildpacks

For more information about using buildpacks on Heroku, see these Dev Center articles:

- [Buildpacks](https://devcenter.heroku.com/articles/buildpacks)
- [Buildpack API](https://devcenter.heroku.com/articles/buildpack-api)

## Locking to a buildpack version

In production, you frequently want to lock all of your dependencies - including
buildpacks - to a specific version. That way, you can regularly update and
test them, upgrading with confidence.

First, find the version you want from [the list of buildpack versions](https://github.com/casetext/heroku-buildpack-firebase/releases).
Then, specify that version with `buildpacks:set`:

```
heroku buildpacks:set https://github.com/casetext/heroku-buildpack-firebase#v1 -a my-app
```

## Feedback

Having trouble? Dig it? Feature request? [Log them here.](https://github.com/casetext/heroku-buildpack-firebase/issues)

## Hacking

To make changes to this buildpack, fork it on Github. Push up changes to your fork, then create a new Heroku app to test it, or configure an existing app to use your buildpack:

```
# Create a new Heroku app that uses your buildpack
heroku create --buildpack <your-github-url>

# Configure an existing Heroku app to use your buildpack
heroku buildpacks:set <your-github-url>

# You can also use a git branch!
heroku buildpacks:set <your-github-url>#your-branch
```

## Testing

The buildpack tests use [Docker](https://www.docker.com/) to simulate
Heroku's Cedar-14 container.

Note that before you run the tests, you will need to have the environment
variables FIREBASE_ADMIN_USER and FIREBASE_ADMIN_PASS set in the host
machine's environment (i.e., the machine you're executing `make test` on).

To run the test suite:

```
make test
```

The tests are run via the vendored [shunit2](http://shunit2.googlecode.com/svn/trunk/source/2.1/doc/shunit2.html)
test framework.

## Disclaimers

This project has no formal affiliation whatsoever with either [Firebase](https://firebase.com) or [Heroku](https://heroku.com). Your mileage may vary, void where prohibited by law.

© 2015 Casetext Inc. Portions © 2013-2015 Heroku Inc. Please see the LICENSE.
