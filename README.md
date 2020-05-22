# puppeteer-runner
Container with tools for running Puppeteer tests for integration tests on local or CI environments

## Usage

* See a full example at /example

* Create a new directory for the new container

* Create a Postman collection with all the tests and verifications you wish to perform when running this container on the server

  * Create the Postman collection, right click on it and export contents to /provisioning/collection.json

  * Take a look at https://learning.getpostman.com/docs/postman/scripts/test_scripts/ for more details
  
* Create Dockerfile

```
FROM flaviostutz/postman-runner
ADD /provisioning /provisioning
```

* Create docker-compose.yml

```yml
version: '3.5'

services:

  my-tests:
    build: .
    ports:
      - 2000:2000
    environment:
      - LOG_LEVEL=debug
      - RUN_ON_STARTUP=true
```

* Run "docker-compose up --build"

* Check test results at container logs

* Open http://localhost:2000/results to see complete results

* Run POST "/test" to trigger a new test execution

## ENVs

* RUN_ON_STARTUP - whetever to run Postman scripts during container startup. defaults to false

* RUN_API_SERVER - whetever to run a REST API server for accepting requests like GET /results, POST /test etc. defaults to true. Set this to false if you wish the container to run, launch test scripts and exit with zero exit code if tests PASSED and not zero if FAILED.

* WAIT_CONNECT_HOST + WAIT_CONNECT_PORT- wait for a successful tcp connection to host:port before starting tests

* WAIT_TIME_SECONDS - time to wait before launching tests (after tcp connect, if defined)

* All ENVs set to your container will be used to replace references in files /provisioning/environment.json and /provisioning/collection.json

  * For example, if you use "value": "${GOOGLE_URL}" in environment.json and you have the "GOOGLE_URL=http://google.com" set as a ENV of your container, during startup it will become "value": "http://google.com"

## Startup scripts

* During startup, if there is a /pre.sh script file, it will be executed. This is optional.

## API

* POST /test
  * Triggers a new test execution on the server
  * You can check the test results at "/status"
  * By using query param "/test?wait=1", the request will wait for the test execution and show results in the response

* GET /status
  * Returns last execution results as HTTP Status:
    * 202 if tests are running
    * 200 if all tests passed
    * 580 if any tests failed
    * 500 if there was an internal server error

* GET /results
  * Returns a HTML page with results from the last execution

* GET /results/json
  * Returns in json for the last execution

* GET /results/json-summary
  * Returns in very small json for the last execution. Usefull when /json returns too much data and you need just the totals

* GET /results/junit
  * Returns the result execution in plain old JUnit XML file

## CI Tips

* In Gitlab environments, you can build and deploy this container along with all your containers
* In .gitlab-ci.yml, after you deploy all your services, make a POST "http://mytests/test" in order to trigger a new test execution
* Then, wait for execution completion by calling GET "/status"

## Development Tips

When running this container with "docker-compose up --build", it will run all scripts inside "examples" container too.

To live edit tests and run without rebuilding/reruning container:

* Mount volumes from the workspace to "/app/example/__tests__". This way, when you edit the scripts on your machine, the same files will be "visible" from inside the container immediatelly.

* Modify docker-compose with "command: sleep 99999"

* Run "docker-compose exec puppeteer-runner bash"

* To run tests when saving example files, just run "jest" inside dir "/app"

* The same procedure can be used with containers that extends this one

