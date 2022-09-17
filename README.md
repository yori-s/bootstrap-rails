# bootstrap-rails

Dockerfile to scaffold a rails app

Build image
```
docker build -t yori-s/bootstrap-rails:latest .
```

bash into a transient container with `/tgt` mounted to the host directory for the new app
```
docker run --rm -it -v ~/git/scratch/kafka-test/sql:/tgt yori-s/bootstrap-rails:latest bash
```

Scaffold the app - in this case with sqlserver
```
rails new /tgt --api -d sqlserver -M -C -A
```

Create a development Dockerfile for the new app
```
./dockerfile-dev.sh > /tgt/Dockerfile-dev
```
