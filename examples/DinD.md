
## With Podman or Docker

```shell

# with Podman
podman run --privileged --rm -it -e PUID=1001 -e PGID=1001  cruizba/ubuntu-dind /bin/bash

# with Docker
docker run --privileged --rm -it -e PUID=1002 -e PGID=1002 cruizba/ubuntu-dind /bin/bash

# once the container is up and running , just run bellow command in Ubuntu container
docker run --rm -it alpine /bin/sh


```


## With k3s

```shell

kubectl apply -f dind.yml

# once the container is up and running 
kubectl get pods

# just exec inside the container
kubectl get exec -it your-pod-name -- /bin/bash

# run bellow command in Ubuntu container
docker run --rm -it alpine /bin/sh

```

