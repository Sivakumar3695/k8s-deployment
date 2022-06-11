# k8s-deployment

## Pre-requisite:
1. mysql is desgined as an external service. Hence, make sure mysql-service is running and replace the mysql-svc url and port in the sso-backend-mysql.yaml file.

## Current-k8s services:
1. sso-backend(accounts app)
2. sso-frontend(acocunts app)
3. Storage service (file manager for apps across my k8s cluster)

Run deploy.sh to set up k8s cluster. 
