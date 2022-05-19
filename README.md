Hello developer!

This is a message from your friendly DevOp!

## Exciting times!
Finally we are moving from a monolith application to a system built upon microservices.

This means that we need a new development environment and build system where the teams working with different services can separate their code and run on different servers!

For this purpose we have chosen Docker in conjunction with our own setup for automation docker that you will find in this repository!

We will start with different teams having the code for their service in different branches. Your team can create as many branches you want, but you should with branching out the main branch and call your base branch "main-your-service-name". Then you can have dev and feature branches according to the same naming convention.

Should we need to separate the code further we might move the code for each service into separate repositories. But we will wait with doing that!

## How to get started!
Checkout the docker branch and write the following in your terminal:

```
./create-docker-tools.sh
```
This will give you two shell scripts (that are git-ignored and thus available in all branches):

```
# start all Docker containers
./start
```

```
# stop all docker containers
./stop
```

### Important! Let the system decide which port you are running your service on

We will send a environment variable called PORT to your container (each branch runs in a container that you setup by writing a Dockerfile in your branch).

Start your service on this port!

### I don't know how to start my service on a specific port

Since you are in control of your microservice and its technology stack it is up to you investigate how to start in on a particular port, but here are some suggestion for technologies we know are going to be used in this project

#### React using the Vite development server

In your **config.vite.js** file:

```js
export default defineConfig({
  plugins: [react()],
  server: {
    // use process.env.PORT
    // to read the environment variable
    port: process.env.PORT
  }
})
```

#### Node.js/Express

```js
// Where you start your Express server
app.listen(process.env.PORT)
```

#### For database containers etc
Still create a separate branch with your Dockerfile (and backup like SQL-dumps etc).

Refer to the documentation about the container you are using (MySQL, MariaDB, MongoDB etc) as to how to start the db server on a particular port!

**Note!** If the server/service needs an argument rather than an environment variable then refter to the Docker documentation on how to read environment varialbes in your Dockerfile and pass them along as arguments in your start CMD!



