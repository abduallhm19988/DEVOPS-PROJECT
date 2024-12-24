
# Kubernetes Cluster Setup and Juice Shop Deployment

This guide provides detailed instructions for setting up a Kubernetes cluster and deploying the Juice Shop application using an NGINX ingress. The setup includes creating a master node, adding worker nodes, and exposing the Juice Shop application inside and outside the cluster.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Kubernetes Cluster Setup](#kubernetes-cluster-setup)
  - [Control-plane Setup](#control-plane-setup)
  - [Worker-node Setup](#worker-node-setup)
- [NGINX Ingress Controller Deployment](#nginx-ingress-controller-deployment)
- [Juice Shop Application Deployment](#juice-shop-application-deployment)
  - [Namespace Creation](#namespace-creation)
  - [Juice Shop Deployment](#juice-shop-deployment)
  - [Juice Shop Service](#juice-shop-service)
  - [Juice Shop Ingress](#juice-shop-ingress)
- [Apply Configurations](#apply-configurations)
- [Access the Juice Shop Application](#access-the-juice-shop-application)
- [Troubleshooting](#troubleshooting)
- [License](#license)

---

## Prerequisites

- A system capable of running Kubernetes (Ubuntu OS recommended).
- Administrative/root access.
- Installed tools: `kubectl`, `kubeadm`, and a configured Ingress controller (e.g., NGINX).

---

## Kubernetes Cluster Setup

### Control-plane Setup

1. **Update and Upgrade:**

    ```bash
    sudo apt update
    sudo apt -y full-upgrade
    sudo ufw status  # Ensure the firewall is inactive
    ```

2. **Disable Swap:**

    ```bash
    sudo swapoff -a
    sudo sed -i.bak -r 's/(.+ swap .+)/#/' /etc/fstab
    ```

3. **Kernel Module Configuration:**

    ```bash
    sudo vim /etc/modules-load.d/k8s.conf
    ```

    Add:

    ```plaintext
    overlay
    br_netfilter
    ```

    Load modules:

    ```bash
    sudo modprobe overlay
    sudo modprobe br_netfilter
    ```

4. **Install Kubernetes Tools:**

    ```bash
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo apt update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
    ```

5. **Initialize the Control-plane:**

    ```bash
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16
    ```

    Configure kubectl:

    ```bash
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```

6. **Install Networking Plugin (Calico):**

    ```bash
    kubectl create -f https://docs.projectcalico.org/manifests/tigera-operator.yaml
    curl -O https://docs.projectcalico.org/manifests/custom-resources.yaml
    nano custom-resources.yaml  # Set CIDR to 10.244.0.0/16
    kubectl apply -f custom-resources.yaml
    ```

---

### Worker-node Setup

1. Follow steps 1-4 above (Control-plane setup).
2. Join the cluster using the token from the control-plane node:

    ```bash
    kubeadm token create --print-join-command
    ```

    Run the token command on the worker node to join the cluster.

---

## NGINX Ingress Controller Deployment

1. Add the NGINX Helm repository:

    ```bash
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    ```

2. Create a namespace for the ingress controller:

    ```bash
    kubectl create namespace ingress-nginx
    ```

3. Install the ingress controller:

    ```bash
    helm install nginx-ingress ingress-nginx/ingress-nginx       --namespace ingress-nginx       --set controller.service.type=NodePort       --set controller.service.nodePorts.http=30080       --set controller.service.nodePorts.https=30443
    ```

4. Verify the ingress controller deployment:

    ```bash
    kubectl get all -n ingress-nginx
    ```

---

## Juice Shop Application Deployment

### Namespace Creation

Create a namespace for the Juice Shop application:

```bash
kubectl create namespace juice-shop
```

---

### Juice Shop Deployment

Create a deployment file (`juice-shop-deployment.yaml`):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: juice-shop
  namespace: juice-shop
spec:
  replicas: 3
  selector:
    matchLabels:
      app: juice-shop
  template:
    metadata:
      labels:
        app: juice-shop
    spec:
      containers:
      - name: juice-shop
        image: bkimminich/juice-shop
        ports:
        - containerPort: 3000
```

---

### Juice Shop Service

Create a service file (`juice-shop-service.yaml`):

```yaml
apiVersion: v1
kind: Service
metadata:
  name: juice-shop-svc
  namespace: juice-shop
spec:
  type: ClusterIP
  selector:
    app: juice-shop
  ports:
    - port: 8080
      targetPort: 3000
```

---

### Juice Shop Ingress

Create an ingress file (`juice-shop-ingress.yaml`):

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: juice-shop-ingress
  namespace: juice-shop
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host:
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: juice-shop-svc
            port:
              number: 8080
```

---

## Apply Configurations

1. Deploy Juice Shop resources:

    ```bash
    kubectl apply -f juice-shop-deployment.yaml
    kubectl apply -f juice-shop-service.yaml
    kubectl apply -f juice-shop-ingress.yaml
    ```

2. Verify deployment, service, and ingress:

    ```bash
    kubectl get all -n juice-shop
    kubectl get ingress -n juice-shop
    ```

---

## Access the Juice Shop Application

- Access the application using the external IP of the ingress controller and the ingress path (`/`).

---

## Troubleshooting

1. **Pod Issues:**
   - Check logs:
     ```bash
     kubectl logs -n juice-shop <pod-name>
     ```

2. **Ingress Issues:**
   - Describe the ingress:
     ```bash
     kubectl describe ingress juice-shop-ingress -n juice-shop
     ```

3. **Service Issues:**
   - Verify service configuration:
     ```bash
     kubectl describe service juice-shop-svc -n juice-shop
     ```

---

## License

MIT
