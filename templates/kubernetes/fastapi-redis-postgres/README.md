# FastAPI, Redis, Postgres deployed with Helm into a Minikube cluster

This is a simple example of how to deploy a FastAPI application with Redis and Postgres into a Minikube cluster using
Helm.  The application is a simple ping service that checks the health of the redis and postgresql databases.

## quick start

```bash
minikube start --driver=docker              # start minikube
eval $(minikube -p minikube docker-env)     # point the shell to the docker environment for minikube
docker build -t localhost/project .         # build the application docker image in the minikube docker environment.
helm install project-release helm-charts/   # install the helm charts
```

Once that has been accomplished we and forward the port to the api.

```bash
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=project,app.kubernetes.io/instance=project-release" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Visit http://127.0.0.1:8080 to use your application"
kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
curl 127.0.0.1:8080/env                  
{"REDIS_HOST":"project-release-redis-master","REDIS_PORT":"6379","REDIS_PASSWORD":"494RN2wdwA","POSTGRES_HOST":"project-release-postgresql","POSTGRES_PORT":"5432","POSTGRES_USER":"db_user","POSTGRES_PASSWORD":"Ea1mjR6ixm"}%    
curl 127.0.0.1:8080/ping
{"postgres":"ok","redis":"ok"}%      
```

## Long form

export the project name to make working in the shell easier.

```bash
export PROJECT=project
```

### helm-charts

Initialize the helm charts and rename the project folder to helm-charts.

```bash
helm create $PROJECT && mv $PROJECT/ helm-charts/ # initialize the helm charts
```

Start minikube and point the shell to the docker environment for minikube and build the application image.

```bash
minikube start --driver=docker --cpus=4 --memory=8g # start minikube with some extra resources
eval $(minikube -p minikube docker-env)             # point the shell to the docker environment for minikube
docker build -t localhost/$PROJECT .                # Now build the application docker image in the minikube docker environment.
```

### update the values

The helm-chats values.yaml need to be updated to use the local docker image.

```yaml
image:
  repository: localhost/<THE_PROJECT_NAME>
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: "latest"
```

```bash
helm dependency build helm-charts/
helm install $PROJECT-release helm-charts/
helm upgrade $PROJECT-release helm-charts/ --values helm/values.yaml --install
```

Running `kubectl get all` outputs the following.

```txt
NAME                                   READY   STATUS    RESTARTS   AGE
pod/project-release-645f9db686-6cx52   1/1     Running   0          29s

NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/kubernetes        ClusterIP   10.96.0.1       <none>        443/TCP   3m2s
service/project-release   ClusterIP   10.106.26.111   <none>        80/TCP    29s

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/project-release   1/1     1            1           29s

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/project-release-645f9db686   1         1         1       29s
```

### updating the api

From now on anytime we need to update the charts we can run `helm upgrade $PROJECT-release helm-charts/`.  This also
tells us how to port-forward to the api.

```txt
Release "project-release" has been upgraded. Happy Helming!
NAME: project-release
LAST DEPLOYED: Sat May 27 10:21:02 2023
NAMESPACE: default
STATUS: deployed
REVISION: 2
NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=project,app.kubernetes.io/instance=project-release" -o jsonpath="{.items[0].metadata.name}")
  export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
```

### port-forwarding

```bash
export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=project,app.kubernetes.io/instance=project-release" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace default $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
echo "Visit http://127.0.0.1:8080 to use your application"
kubectl --namespace default port-forward $POD_NAME 8080:$CONTAINER_PORT
```

The application is running but none of the environment variables are set and we haven't yet deployed the redis or postgresql databases.

### Adding the dependencies

The bitnami helm charts provide a good starting point for adding the redis and postgresql dependencies. Simply clone
the bitnami charts and copy the redis and postgresql charts to the dependencies folder.

```bash
export TMP_DIR=/tmp/bitnami-charts
git clone https://github.com/bitnami/charts.git $TMP_DIR --depth 1
mkdir ./helm-charts/dependencies/ && pushd ./helm-charts/dependencies/
cp -r $TMP_DIR/bitnami/redis/ .
cp -r $TMP_DIR/bitnami/postgresql/ .
cp -r $TMP_DIR/bitnami/common/ .
rm -rf $TMP_DIR
popd
unset TMP_DIR
```

4 files needed to be updated to add the dependencies and map the environment variables.

- helm-charts/Chart.yaml
- helm-charts/values.yaml
- helm-charts/templates/deployment.yaml
- helm-charts/templates/_helpers.tpl

#### update the Chart.yaml

Add the following dependencies to the helm-charts/Chart.yaml

```yaml
# helm-charts/Chart.yaml
dependencies:
  - name: common
    repository: file://dependencies/common
    tags:
      - bitnami-common
    version: 2.x.x
  - condition: redis.enabled
    name: redis
    repository: file://dependencies/redis
    version: 17.x.x
  - condition: postgresql.enabled
    name: postgresql
    repository: file://dependencies/postgresql
    version: 12.x.x
```

We need to update the values.yaml to enable the redis and postgresql dependencies.

```yaml
# helm-charts/values.yaml
redis:
  enabled: true

postgresql:
  enabled: true
  auth:
    enablePostgresUser: false
    username: db_user
```

Now with the dependencies added the Chart.yaml and values.yaml updated we can rebuild the dependencies.

```bash
helm dependency build helm-charts/ # rebuild the dependencies
helm upgrade $PROJECT-release helm-charts/ --install # upgrade the release
```

```bash
minikube stop && minikube delete --all --purge 
minikube start --driver=docker --cpus=4 --memory=8g
eval $(minikube -p minikube docker-env)
docker build -t localhost/$PROJECT .
helm install $PROJECT-release helm-charts/
```
