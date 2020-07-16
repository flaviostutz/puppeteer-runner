# puppeteer-runner

[<img src="https://img.shields.io/docker/automated/flaviostutz/puppeteer-runner"/>](https://hub.docker.com/r/flaviostutz/puppeteer-runner)

Container with tools for running Puppeteer tests for integration tests on local or CI environments

## Usage

* See a full example at /example

* Create a new directory for the new container

* Inside dir "__tests__" place your puppeteer test scripts
  
* Create Dockerfile

```
FROM flaviostutz/puppeteer-runner
ADD /__tests__ /app/__tests__
```

* Create docker-compose.yml

```yml
version: '3.5'

services:

  my-tests:
    build: .
```

* Run "docker-compose up --build"

* Check test results at container logs

## ENVs

* WAIT_CONNECT_HOST + WAIT_CONNECT_PORT- wait for a successful tcp connection to host:port before starting tests

* WAIT_TIME_SECONDS - time to wait before launching tests (after tcp connect, if defined)

* JEST_TEST_TIMEOUT - Default Jest tests timeout.defaults to '10000'

* JEST_MAX_CONCURRENCY - Max parallel tasks in Jest. defaults to '5'

* JEST_RUN_IN_BAND - Run one test suite at a time, with no concurrency. Useful for debugging. defaults to 'false'

* JEST_MAX_FAILURES '1' - Number of failed test suites before interrupting tests

## Startup scripts

* During startup, if there is a /pre.sh script file, it will be executed. This is optional.

## CI Tips

You can use this container for automatic testing on Dockerhub or someother CI server by creating a docker-compose.test.yml file containing this container with tests and the target container being tested, so that everytime the target container gets built, the puppeteer tests will run and if any tests fails, the build will fail too.

* See an example of this mechanism at https://github.com/flaviostutz/simple-file-server

## Development Tips

When running this container with "docker-compose up --build", it will run all scripts inside "examples" container too.

To live edit tests and run without rebuilding/reruning container:

* Mount volumes from the workspace to "/app/example/__tests__". This way, when you edit the scripts on your machine, the same files will be "visible" from inside the container immediatelly.

* Modify docker-compose with "command: sleep 99999"

* Run "docker-compose exec puppeteer-runner bash"

* To run tests when saving example files, just run "jest" inside dir "/app"

* The same procedure can be used with containers that extends this one

