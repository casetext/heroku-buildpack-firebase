# Heroku Buildpack for Firebase

![Firebase]()

This is an unofficial buildpack to automatically provision Firebase instances for Heroku apps.

## Documentation

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

## Options

### Specify a set of security rules



Set engines.node in package.json to the semver range
(or specific version) of node you'd like to use.
(It's a good idea to make this the same version you use during development)

```json
"engines": {
  "node": "0.11.x"
}
```

```json
"engines": {
  "node": "0.10.33"
}
```

Default: the latest stable version.

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
Heroku's Cedar and Cedar-14 containers.

To run the test suite:

```
make test
```

Or to just test in cedar or cedar-14:

```
make test-cedar-10
make test-cedar-14
```

The tests are run via the vendored [shunit2](http://shunit2.googlecode.com/svn/trunk/source/2.1/doc/shunit2.html)
test framework.

## Disclaimers

This project has no formal affiliation whatsoever with either [Firebase](https://firebase.com) or [Heroku](https://heroku.com). Your mileage may vary, void where prohibited by law.
