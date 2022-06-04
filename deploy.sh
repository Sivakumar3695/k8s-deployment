#!/bin/bash

REQUIRED_PKG="docker-ce"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get update && sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
  echo "Successfully installed docker-ce"
else
  echo "docker-ce already installed."
fi

MINIKUBE_INSTALLED=$(dpkg -S `which minikube` | grep "error")
if [ "" != "$MINIKUBE_INSTALLED" ]; then
    echo "Minikube not installed. Hence, installing minikube."
    
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    echo "Successfully installed Minikube."
else 
    echo "Minikube already installed."
fi

alias kubectl="minikube kubectl --"
echo "stating minikube..."
minikube start
kubectl apply -f app/storage-svc/storage-svc.yaml
kubectl apply -f app/sso-app/sso-backend-mysql.yaml
kubectl apply -f app/sso-app/sso-backend.yaml
kubectl apply -f app/sso-app/sso-frontend-nginx-conf.yaml
kubectl apply -f app/sso-app/sso-frontend.yaml

echo "Check: minikube kubectl -- get pods"
echo "If all pods are up and running, check this url (http://$(minikube ip):30000) to access our service."
