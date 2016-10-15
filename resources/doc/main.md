# Main #

## How to build ##

* ```cd docker && ./build.sh```
* ```./docker/build.sh -p ./docker```

set image name (dind-pack by default)

```
./docker/build.sh -i other_image_name
```

set workdir (/usr/share/dind-pack by default)

```
./docker/build.sh -w /other/workdir
```

## How to run ##

* ```./docker/run.sh```

set image name (dind-pack by default)

```
./docker/run.sh -i other_image_name
```

set container name (same as image name by default)

```
./docker/run.sh -c other_container_name
```

## How to debug ##

```
DIND_PACK_DEBUG=true ./docker/build.sh [args..]
```
