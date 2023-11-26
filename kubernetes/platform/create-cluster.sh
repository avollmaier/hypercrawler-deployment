#!/bin/sh

echo "\n📦 Initializing Kubernetes cluster...\n"

#ctlptl create cluster minikube --registry=ctlptl-registry --kubernetes-version=v1.28.1

minikube start --cpus 8 --memory 16g --driver docker --profile hypercrawler --kubernetes-version=v1.28.3

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

kubectl port-forward --namespace default service/hypercrawler-mongo 27017:27017 >/dev/null 2>&1 &

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

kubectl port-forward --namespace default service/hypercrawler-neo4j 7687:7687 >/dev/null 2>&1 &

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

kubectl port-forward --namespace default service/hypercrawler-rabbitmq 15672:15672 >/dev/null 2>&1 &

## ask user if they want to deploy observability stack

while true; do
    read -p "📦 Deploy observability stack? (y/n)" yn
    case $yn in
        [Yy]* ) chmod +x ./observability/deploy.sh;cd observability;./deploy.sh;echo "Observability stack deployed successfully!";break;;
        [Nn]* ) echo "Observability stack deployment canceled.";exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


echo "\n⛵ Happy Sailing!\n"