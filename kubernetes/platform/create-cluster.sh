#!/bin/sh

echo "\n📦 Initializing Kubernetes cluster...\n"

ctlptl create cluster minikube --registry=ctlptl-registry --kubernetes-version=v1.26.3

echo "\n📦 Deploying platform services..."

kubectl apply -f services

sleep 5

echo "\n⌛ Waiting for MongoDB to be deployed..."

while [ $(kubectl get pod -l db=hypercrawler-mongo | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for MongoDB to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=hypercrawler-mongo \
  --timeout=360s

sleep 5

echo "\n⌛ Waiting for Neo4j to be deployed..."

while [ $(kubectl get pod -l db=hypercrawler-neo4j | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for Neo4j to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=hypercrawler-neo4j \
  --timeout=360s

echo "\n📦 Deploying RabbitMQ..."

kubectl apply -f services/rabbitmq.yml

sleep 5

echo "\n⌛ Waiting for RabbitMQ to be deployed..."

while [ $(kubectl get pod -l db=hypercrawler-rabbitmq | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for RabbitMQ to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=hypercrawler-rabbitmq \
  --timeout=180s


echo "\n⛵ Happy Sailing!\n"