![CI/CD](../../static/ci_cd.png?raw=true "CI/CD")

## CI

The [CI stage](ci.yaml) is executed for every pull request. 
It performs the following tasks:
- installing necessary package dependencies
- running lint
- running tests

## Deploy and Build to Staging

After a pull request is approved and merged, the [deploy-staging.yaml](deploy-staging.yaml) workflow is triggered. 
This workflow configures:
- AWS credentials
- builds and pushes a Docker image with a specific release tag 
- configures the ECS task definition to use the Docker image release tag
- deploys the ECS task with the new task definition, and waits for the ECS service to stabilize
- creates a draft release that can be manually approved and published later.

## Deploy to production

Once we are satisfied with the application running on the staging environment, we can publish the previously created draft release.  
This triggers the [deploy-production.yaml](deploy-production.yaml) workflow, which deploys the same Docker image tag that is already running on the staging environment.  
In case of a deployment or application failure (health-check fail), the workflow will fetch the latest successful run of deploy-production.yaml and trigger a re-run, rolling back the deployment to the previously successful one.  
It will also reset the current active release to the one that was rolled back.

## Deploy to specific env
If you want to deploy a specific application release to particular environments, you can choose to run the [deploy-env.yaml](deploy-env.yaml) workflow manually. Simply select the environment and set the desired release version for deployment.
