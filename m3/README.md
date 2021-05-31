# Docker Swarm

## Deploying web application on several machines joined in docker swarm

The only thing that needs to be executed is `vagrant up` and the machines will be set up and application will be deployed automatically.

In settings.yml are located variables for the virtual machines and swarm settings.

When the main(manager) machines is up a script will be executed in the background to wait for the specified number of nodes to join the swarm so the application to be deployed.

The web page is on <http://localhost:3001>

The rest api is on <http://localhost:8001>

### Example rest api call

```http
GET http://localhost:8001/search?q=volks&page=0&size=40
```

### Status of the rest api

```http
GET http://localhost:8001/actuator/health
```
