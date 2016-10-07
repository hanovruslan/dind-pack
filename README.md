# Docker in Docker pack #

... and all of these inside Vagrant

![We need to go deeper](./resources/img/we-need-to-go-deeper.jpg "We need to go deeper")

## What can you do ##

1. create VM (vagrant up --provision)
1. create dind container (./docker/build.sh)
1. mount your app inside dind container
1. build any available container that match exactly your app
1. mount your app inside your container
1. run (dev or prod)
1. commit container
1. push to the registry


## How ##

```
$ vagrant up --provision && vagrant ssh
$ /vagrant/docker/build.sh [image-name]
```
