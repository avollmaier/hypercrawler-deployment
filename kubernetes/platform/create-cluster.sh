#!/bin/sh

echo "\n📦 Initializing Kubernetes cluster...\n"

ctlptl create cluster minikube --registry=ctlptl-registry --kubernetes-version=v1.26.3

echo "\n⛵ Happy Sailing!\n"