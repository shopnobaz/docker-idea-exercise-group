Hello developer!

This is a message from your friendly DevOp!

## Exciting times!
Finally we are moving from a monolith application development model to systems built upon microservices.

This means that we need a new development environment and build system where the teams working in the same main project, but with different services can separate their code and run it on different servers!

For this purpose we have chosen Docker in conjunction with our own setup for automating Docker.

We will start with 
* different teams in teh same main project having the code for their service in specific branches.
* your team can create as many branches you want, but you start with branching out the main branch and call your base branch "main-service-name".
* then you can create dev and feature branches according to the same naming convention (dev-service-name, feature-some-feature-service-name etc).

**Note:** Should we need to separate the code further we might move each service into separate repositories. But we will wait with doing that.

## How to get started!
Checkout the docker branch and run the following command in your terminal:

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

(You will also see a git ignored folder called docker-tools. There is *no need* for you to work in this folder.)

### In your branch
Make sure there is: A docker file which specifies at least:
* a base image (FROM) 
* and a command to run (CMD) when the server starts.

Example:

```


### Important! Let the system decide which port you are running your service on

We will send an environment variable called PORT to your container (each branch runs in a container that you setup by writing a Dockerfile in your branch).

Start your service on this port!

#### I don't know how to start my service on a specific port

Since you are in control of your microservice and its technology stack it is up to you investigate how to start in on a particular port, but here are some suggestion for technologies we know are going to be used in this project

##### React using the Vite development server

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

##### Node.js/Express

```js
// Where you start your Express server
app.listen(process.env.PORT)
```

#### For database containers etc
Create a separate branch with your Dockerfile (and backup like SQL-dumps etc).

Refer to the documentation about the container you are using (MySQL, MariaDB, MongoDB etc) for how to start the db server on a particular port!

**Important!** If the server/service needs a command line argument rather than an environment variable to set the port it is starting on -  refter to the Docker documentation on how to read environment variables in your Dockerfile and pass them along as comman line arguments in your start CMD!



