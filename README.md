# Demo Devops Python

This is a simple application to be used in the technical test of DevOps.

# Technical Decisions Explained

## Dockerization
- Used official `python:3.11-slim` image to keep the container lightweight and secure.
- Installed dependencies via `requirements.txt`.
- Set `PYTHONDONTWRITEBYTECODE` and `PYTHONUNBUFFERED` for optimal Docker behavior.
- multi stage build wasn't necessary 

## Database Storage
- SQLite was chosen because the project scope indicated local persistence.
- To ensure database availability across pod restarts, an `emptyDir` Kubernetes volume was mounted specifically at `/app/db`.

## Kubernetes Deployment
- Readiness and liveness probes were configured targeting `/api/users/` endpoint to ensure pod health.
- Environment variables were used to make settings flexible (`DATABASE_NAME`, `DJANGO_ALLOWED_HOSTS`).

## CI/CD
- GitHub Actions pipelines were created to automate:
  - Code linting (flake8)
  - Unit tests and coverage reporting
  - Docker image building and pushing
  - No deployment to k8s was defined, because I used a local minikube cluster(common steps here involve a connection to the remote cluster and change of k8s manifests)

## Security
- Environment variables were used for parametrized values.(we don't have any sensitive values here.
- For prod ready apps we need to utilize secrets to protect senssitive data, but secrets only provide base64 obfuscation, so the correct approach is a truly encrypted option like hasicorp Vault or helm secrets
- ALLOWED_HOSTS in Django was managed dynamically using environment settings.

## Best Practices
- Split manifests: `k8s/` directory holds deployment and service separately.
- Applied Docker caching optimizations (`--no-cache-dir`).
- run out of time for deployment to EKS with IaC definition ussing terraform

## screenshots

![Screenshot 2025-04-29 at 11 45 56 AM](https://github.com/user-attachments/assets/b0e33b76-32f9-4676-9d29-13cb04a35d0a)

<img width="356" alt="Screenshot 2025-04-29 at 11 46 30 AM" src="https://github.com/user-attachments/assets/468a8bd4-2f47-4e82-ae62-3112beab5f01" />

![Screenshot 2025-04-28 at 11 33 49 PM](https://github.com/user-attachments/assets/b3ff55f7-39d5-481f-b9c0-058743e8250a)
![Screenshot 2025-04-29 at 12 52 41 AM](https://github.com/user-attachments/assets/b18dfb16-199f-4250-b00c-6bdfa3d4ddf9)

![Screenshot 2025-04-29 at 1 55 52 AM](https://github.com/user-attachments/assets/fe69dcdc-65d5-402b-a5c6-b4e947b08ad6)
![Screenshot 2025-04-29 at 10 57 08 AM](https://github.com/user-attachments/assets/13b9a8b3-4eb8-4fa9-8b6c-62c87a5736cc)
![Screenshot 2025-04-29 at 11 26 27 AM](https://github.com/user-attachments/assets/8d3a043d-1112-4fd9-b053-8cdc8ebb83ce)
![Screenshot 2025-04-29 at 11 24 19 AM](https://github.com/user-attachments/assets/151f323f-69a2-4706-acf1-7cb88cdef116)


## Getting Started

### Prerequisites

- Python 3.11.3

### Installation

Clone this repo.

```bash
git clone https://bitbucket.org/devsu/demo-devops-python.git
```

Install dependencies.

```bash
pip install -r requirements.txt
```

Migrate database

```bash
py manage.py makemigrations
py manage.py migrate
```

### Database

The database is generated as a file in the main path when the project is first run, and its name is `db.sqlite3`.

Consider giving access permissions to the file for proper functioning.

## Usage

To run tests you can use this command.

```bash
py manage.py test
```

To run locally the project you can use this command.

```bash
py manage.py runserver
```

Open http://localhost:8000/api/ with your browser to see the result.

### Features

These services can perform,

#### Create User

To create a user, the endpoint **/api/users/** must be consumed with the following parameters:

```bash
  Method: POST
```

```json
{
    "dni": "dni",
    "name": "name"
}
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
{
    "id": 1,
    "dni": "dni",
    "name": "name"
}
```

If the response is unsuccessful, we will receive status 400 and the following message:

```json
{
    "detail": "error"
}
```

#### Get Users

To get all users, the endpoint **/api/users** must be consumed with the following parameters:

```bash
  Method: GET
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
[
    {
        "id": 1,
        "dni": "dni",
        "name": "name"
    }
]
```

#### Get User

To get an user, the endpoint **/api/users/<id>** must be consumed with the following parameters:

```bash
  Method: GET
```

If the response is successful, the service will return an HTTP Status 200 and a message with the following structure:

```json
{
    "id": 1,
    "dni": "dni",
    "name": "name"
}
```

If the user id does not exist, we will receive status 404 and the following message:

```json
{
    "detail": "Not found."
}
```

## License

Copyright © 2023 Devsu. All rights reserved.
