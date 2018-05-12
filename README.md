OpenFaaS NATS Connector
===

What is OpenFaaS
---
With OpenFaaS you can package anything as a serverless function - from Node.js to Golang to CSharp, even binaries like ffmpeg or ImageMagick.

What is NATS
---

NATS Server is a simple, high performance open source messaging system for cloud native applications, IoT messaging, and microservices architectures.

Why do I need a Trigger
---

It's not always necessary to always trigger your functions using HTTP. Sometimes we would like to trigger functions by 
events. NATS Provides a messaging layer between your functions and the wider internet. By using a messaging layer we can
queue our function calls allowing us to trigger out functions from events happening in your application.

Why is event driven useful?
---

Traditionally when we wrote code our backend was one application backed by a database of some sorts. As we move to a more
distributed application architecture not all of our services will be served by a single database. Using events we can abstract
the database away from the calling application and use a series of serverless functions, web servers, containers and third party
services without maintaining a single database for the whole application.

How does this work?
---

You deploy this container or pod inside your OpenFaaS Namespace. Connect up your NATS cluster by providing an environment 
variable and you are ready to start triggering events!

_Kubernetes_

- [how to deploy NATS on Kubernetes!](https://github.com/pires/kubernetes-nats-cluster)
- [how to deploy OpenFaaS on Kubernetes!](https://github.com/openfaas/faas-netes/blob/master/chart/openfaas/README.md)

_Docker Swarm_

- [How to deploy OpenFaaS on Docker Swarm](https://docs.openfaas.com/deployment/docker-swarm/)
- [How to deploy NATS on Docker Swarm](https://nats.io/documentation/tutorials/nats-docker-swarm/)

Triggering your Functions
---

Our functions are triggered from a function.call topic we publish to NATS. See the example nats-pub*.rb files.

When publishing a message to the queue we use the following format.

Synchronous Functions
```
{
  function: 'figlet', 
  params: {
    body: 'Hello World'
  }
}
```

Asynchronous Functions
```
{
  function: 'figlet', 
  params: {
    callback_url: 'http://your-callback.url/example'
    body: 'Hello World'
  }
}
```

The NATS Client container is smart enough to distinguish between asynchronous calls and synchronous calls based on the
callback_url. If it is present we will perform an async function call, else we perform a synchronous call.

Its as simple as that.

Deploying
---

_Kubernetes_

Deploy the deployment/k8s/deployment.yml to your openfaas namespace

`$ kubectl apply -f deployment/k8s/deployment.yml`

_Docker_

```
$ docker run -d -e NATS_HOST=nats://nats:4222 \
                -e FAAS_HOSt=http://faas:8080 \
                affixxx/openfaas-nats-connector
```


ToDo
---

- Handle OpenFaaS Gateway Authentication
- Handle NATS Authentication
- Go Rewrite
- Deploying to Docker Swarm