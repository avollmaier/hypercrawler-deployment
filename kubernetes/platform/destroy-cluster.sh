#!/bin/sh

echo "\n🏴️ Destroying Kubernetes cluster...\n"

minikube stop

minikube delete

echo "\n🏴️ Cluster destroyed\n"
