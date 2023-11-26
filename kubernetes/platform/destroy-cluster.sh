#!/bin/sh

echo "\n🏴️ Destroying Kubernetes cluster...\n"

minikube stop --profile hypercrawler

minikube delete  --profile hypercrawler

echo "\n🏴️ Cluster destroyed\n"
