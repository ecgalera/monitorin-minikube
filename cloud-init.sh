#!/bin/bash
set -e

# Crear el namespace de monitoring
kubectl create namespace monitoring

# Crear los manifiestos de Kubernetes
mkdir -p /home/ubuntu/manifests

# Manifiesto de Nginx
cat <<EOF > /home/ubuntu/manifests/nginx.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx:latest
        name: nginx
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: monitoring
spec:
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: nginx
  type: NodePort
EOF

# Manifiesto de Grafana
cat <<EOF > /home/ubuntu/manifests/grafana.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
      - image: grafana/grafana:latest
        name: grafana
        ports:
        - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: monitoring
spec:
  ports:
  - port: 3000
    targetPort: 3000
  selector:
    app: grafana
  type: NodePort
EOF

# Manifiesto de Prometheus
cat <<EOF > /home/ubuntu/manifests/prometheus.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: monitoring
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus
  template:
    metadata:
      labels:
        app: prometheus
    spec:
      containers:
      - image: prom/prometheus:latest
        name: prometheus
        ports:
        - containerPort: 9090
---
apiVersion: v1
kind: Service
metadata:
  name: prometheus
  namespace: monitoring
spec:
  ports:
  - port: 9090
    targetPort: 9090
  selector:
    app: prometheus
  type: NodePort
EOF

# Aplicar los manifiestos
kubectl apply -f /home/ubuntu/manifests/

echo "Manifiestos aplicados correctamente" >> /var/log/user-data.log
