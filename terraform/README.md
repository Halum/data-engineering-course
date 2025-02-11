# Terraform Docker Setup

## Index
- [Terraform Docker Setup](#terraform-docker-setup)
  - [Index](#index)
  - [Build the Docker Image](#build-the-docker-image)
  - [Run the Docker Container](#run-the-docker-container)
  - [Use the Container Terminal Interactively](#use-the-container-terminal-interactively)
  - [Start Existing Container](#start-existing-container)
  - [Stop Running Container](#stop-running-container)
  - [Common Terraform Commands](#common-terraform-commands)

## Build the Docker Image

To build the Docker image named `de-terra`, run the following command in the directory where the Dockerfile is located:

```sh
docker build -t de-terra .
```

## Run the Docker Container

To run the Docker container with port mapping to 8000 and mount the current directory, use the following command:

```sh
docker run -d -p 8000:8000 -v "$(pwd)":/app --name de-terra de-de-terra
```

This command will:
- Run the container in detached mode (`-d`).
- Map port 8000 on the host to port 8000 in the container (`-p 8000:8000`).
- Mount the current directory to `/app` in the container (`-v "$(pwd)":/app`). Which will only help to see files via the python server.
- Name the container `de-terra` (`--name de-terra`).

## Use the Container Terminal Interactively

To access the terminal of the running container interactively, use the following command:

```sh
docker exec -it de-terra /bin/sh
```

This command will:
- Attach to the running container named `de-terra`.
- Open an interactive terminal session (`-it`).
- Use `/bin/bash` as the shell.

## Start Existing Container

If the container named `de-terra` already exists and is stopped, you can start it using the following command:

```sh
docker start de-terra
```

This command will:
- Start the existing container named `de-terra`.

## Stop Running Container

To stop the running container named `de-terra`, use the following command:

```sh
docker stop de-terra
```

This command will:
- Stop the running container named `de-terra`.

## Common Terraform Commands

Here are some common Terraform commands for quick access:

- Initialize a Terraform configuration:
  ```sh
  terraform init
  ```

- Validate the Terraform configuration:
  ```sh
  terraform validate
  ```

- Plan the Terraform changes:
  ```sh
  terraform plan
  ```

- Apply the Terraform changes:
  ```sh
  terraform apply
  ```

- Destroy the Terraform-managed infrastructure:
  ```sh
  terraform destroy
  ```

- Format the Terraform configuration files:
  ```sh
  terraform fmt
  ```

- Show the current state:
  ```sh
  terraform show
  ```

- List the resources in the state file:
  ```sh
  terraform state list
  ```

- Remove a resource from the state file:
  ```sh
  terraform state rm <resource_name>
  ```

