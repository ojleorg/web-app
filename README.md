## Infrastructure Technology stack
Production             |  Non prod
:-------------------------:|:-------------------------:
![Production environment](./static/prod.png?raw=true "Production environment") | ![Non-prod environments](./static/non_prod.png?raw=true "Non-prod environments")

- The application is deployed on the AWS Fargate service, with each environment (test, demo, staging, production) operating on its dedicated cluster.
- Non-production clusters utilize spot instances and minimal task resources to optimize cost efficiency, while the production cluster is configured with an autoscaling policy (minimum 1, maximum 10 tasks) triggered by CPU/Memory utilization exceeding 80%.
- Cloudwatch is responsible for monitoring logs and metrics, ensuring the health and performance of the application across all environments.
- Environment files specific to each environment are stored in an S3 bucket and fetched from the task definition using the `environmentFiles` parameter.
- Secrets required for the application are retrieved from AWS Secrets Manager as specified in the task definition, enhancing security and access control.
- Furthermore, Systems Manager (SSM) task exec role is activated on non-production clusters to facilitate troubleshooting activities.


## Code Technology stack

Important tools used for this service are as follows:

- [Python](https://www.python.org/downloads/release/python-368/) - Python 3.6
- [Flask](https://flask.palletsprojects.com/) - Flask python web framework
- [Docker](https://www.docker.com/) - Local development and deploy
- [GitHub](https://github.com/) - Code sourcing and CI

## Local Development

#### To run the Flask webapp locally with Docker:

1. Build the docker image providing target 'app'  
    `$ docker build --target app -t web-app:latest .`

1. Run the latest image id providing env-file and bind port 5000  
    `$ docker run --env-file=./dotenv/.env.local -dp 5000:5000 web-app:latest`

#### To run the Flask webapp locally with Python 3.6 in virtualenv:

1. Create the virtualenv
    `$ virtualenv ./venv/`
1. Activate the virtualenv
    `$ . ./venv/bin/activate`
1. Install pip dependencies
    `(venv)$ pip install -r requirements.txt`
1. Copy .env.local file to .env for autoloading environment
    `(venv)$ cp ./dotenv/.env.local .env`
1. Run the uwsgi python server
    `(venv)$ uwsgi --socket 0.0.0.0:5000 --protocol=http -w wsgi:app`


### Source control and contributing
The code for this service is hosted and sourced on [GitHub](www.github.com). 
Appart from sourcing, we have a GitHub Actions pipelines up and running.

#### Starting the feature
Before starting the work on a new feature make sure you first pull the latest changes from the remote main branch.

```bash
git fetch
git checkout main
git pull
```
or without the fetch if it's not the first time pulling the changes from remote.

After that, create a new feature branch following the "feature/some-stuff" convention.
```bash
git checkout -b feature/some-stuff
```
You are good to go!
#### Before pushing

Before pushing your changes to remote, check if all the tests, linter and flake passes, by running
```bash
flake8 .
```

It is important to run tests **inside** a docker container so we are sure everything will behave as expected once deployed to production.
Although running tests in a container is always engouraged, doing so during main(especially if you are doing TDD) would slow you down greatly.
Just run them normally with
```bash
pytest
```
and after you are done, do the former.

If remote main branch had some changes in the mean time while you were doing the feature, make sure you pull latest main and merge main into your feature branch.
Additionally, resolve any conflicts if they do occur. You can achieve this by doing the following:
```bash
git checkout main
git pull
git checkout feature/some-stuff
git merge main
```
After successfully merging, make sure to repeat the steps above so you are sure nothing broke during the merge!


#### Pushing to remote

If you got this far, it means it's time to push your changes to remote and create a pull request to main branch.
You can push your changes using
```bash
git push origin feature/some-stuff
```
Next, create a merge request on GitHub by setting source branch to your feature branch, and target branch to main.
GitHub Pull request sets the target branch to main by default.

After creating a merge request, you should see GitHub Actions pipline getting triggered with a CI job in it. 
If all goes well, someone will review the merge request and approve it and merge.
