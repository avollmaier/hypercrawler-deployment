#!/bin/sh

echo "\n📦 Initializing Kubernetes cluster...\n"

ctlptl create cluster minikube --registry=ctlptl-registry --kubernetes-version=v1.26.3

echo "\n🔌 Enabling NGINX Ingress Controller...\n"

minikube addons enable ingress

sleep 30

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
  --timeout=180s

echo "\n⛵ Happy Sailing!\n"