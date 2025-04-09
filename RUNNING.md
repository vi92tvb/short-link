# How to Shortlink Application

---
## Prerequisites
Before running the Rails application with Docker, ensure you have the following installed:

- **Docker**: Install Docker from [here](https://www.docker.com/get-started).
- **Docker Compose**: Docker Compose is usually bundled with Docker Desktop.

### 1. Install Docker
To check if Docker is installed, run:
```bash
docker --version
```
If Docker is not installed, download and install Docker from [Docker's official website](https://www.docker.com/get-started).

### 2. Install Docker Compose
To check if Docker Compose is installed, run:
```bash
docker-compose --version
```
If Docker Compose is not installed, download and install it from [Docker Compose installation guide](https://docs.docker.com/compose/install/).

---

# Setting Up the Project with Docker

### 1. Clone the Repository

If you haven't cloned the repository yet, do so with:
```bash
git clone https://github.com
cd shortlink
```

### 2. Create the Docker Environment

The project includes a `docker-compose.yml` file to define the containers required for the application. This file will configure everything needed to run the app.

### 3. Build the Docker Containers

In the root directory of your project, run the following command to build the Docker images:
```bash
docker-compose build
```

### 4. Set Up the Database
To set up the database (create and migrate), run:
```bash
docker-compose run web rails db:create
docker-compose run web rails db:migrate
```

If your app uses environment variables (e.g., API keys, secret keys), make sure to create a `web.env` file in the project root and include the necessary variables. For example:
```
DB_HOST=
DB_PORT=
DB_NAME_DEV=
DB_NAME_TEST=
DB_NAME_PROD=
DB_USERNAME=
DB_PASSWORD=
APP_DOMAIN=
```

---

# Running the Application

### 1. Start the Docker Containers

To start the app, run the following command:
```bash
docker-compose up
```
This will start the Rails server along with any necessary services (like PostgreSQL). By default, the app will be available at `http://localhost:3000`.

---

## Running Tests

If you want to run the test suite to verify everything is working, you can run:

```bash
docker-compose run web rspec
```

---

# Troubleshooting

### Common Issues

- **Missing Dependencies**: If you encounter missing dependencies, run:
  ```bash
  docker-compose build
  docker-compose run web bundle install
  ```

- **Database Errors**: If you get errors related to the database (e.g., missing tables or columns), make sure you've run:
  ```bash
  docker-compose run web rails db:create
  docker-compose run web rails db:migrate
  ```

- **Port Conflicts**: If the server is already running on port 3000, you can change the port by editing the `docker-compose.yml` file, or you can specify a different port when starting the app:
  ```bash
  docker-compose up
  ```
  By default, the application will be exposed on `localhost:3000`.
