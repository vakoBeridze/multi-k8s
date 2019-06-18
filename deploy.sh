#!/usr/bin/env bash
docker build -t vakob/multi-client:latest -t vakob/multi-client:$SHA vako -f ./client/Dockerfile ./client
docker build -t vakob/multi-server:latest -t vakob/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t vakob/multi-worker:latest -t vakob/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push vakob/multi-client:latest
docker push vakob/multi-server:latest
docker push vakob/multi-worker:latest

docker push vakob/multi-client:$SHA
docker push vakob/multi-server:$SHA
docker push vakob/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=vakob/multi-server:$SHA
kubectl set image deployments/client-deployment client=vakob/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=vakob/multi-worker:$SHA