#!/bin/bash
VERSION=5.13.allclouds
DOCKERHUB=coronawhy 
docker build -t ${DOCKERHUB}/dataverse:${VERSION} -f docker/dataverse-k8s/payara/Dockerfile .
