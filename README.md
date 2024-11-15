## Webapp Technology stack

- Webapp is simple HTML/JS static app served on Nginx with access controlled by Keycloak login
- The Keycloak access user is configured within the Ansible roles and further more secret provisioned via Github secrets

## Infrastructure and provisioning

- Infrastructre is provisioned within Terraform IaC, by running the `Infra provisioning` workflow.
- The application is deployed on provisioned GCP VM instance within `gcp_webapp` instance specific labels.
- VM configuration and application deployment is done via Ansible, further more utilizing Docker compose.
- Secrets required for the application are retrieved from Github Secrets, within the CI/CD workflow.
- Destroying the environment is done within same `Infra provisioning`, by choosing `action: destroy`

