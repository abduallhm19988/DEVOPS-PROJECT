
# Kubernetes Cluster Setup

This guide provides step-by-step instructions for setting up a Kubernetes Cluster, including both the Control-plane and Worker-node configurations. It covers software installations, kernel and network configurations, and initializing the cluster.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Control-plane Setup](#control-plane-setup)
  - [Update and Upgrade](#update-and-upgrade)
  - [Time Synchronization](#time-synchronization)
  - [Disable Swap](#disable-swap)
  - [Kernel Module Configuration](#kernel-module-configuration)
  - [Network Configuration](#network-configuration)
  - [Install Software Tools](#install-software-tools)
  - [Install Kubernetes Tools](#install-kubernetes-tools)
  - [Install and Configure Containerd](#install-and-configure-containerd)
  - [Initialize Control-plane](#initialize-control-plane)
  - [Install Helm](#install-helm)
  - [Install Ingress Controller](#install-ingress-controller)
- [Worker-node Setup](#worker-node-setup)
  - [Update and Upgrade](#update-and-upgrade-1)
  - [Time Synchronization](#time-synchronization-1)
  - [Disable Swap](#disable-swap-1)
  - [Kernel Module Configuration](#kernel-module-configuration-1)
  - [Network Configuration](#network-configuration-1)
  - [Install Software Tools](#install-software-tools-1)
  - [Install Kubernetes Tools](#install-kubernetes-tools-1)
  - [Install and Configure Containerd](#install-and-configure-containerd-1)
  - [Join Cluster](#join-cluster)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

- **Operating System**: Ubuntu (ensure it's updated to the latest supported version)
- **User Privileges**: Administrative or root access
- **Network**: Ensure nodes can communicate with each other
- **Swap**: Must be disabled on all nodes

---

## Control-plane Setup

### Update and Upgrade

```bash
sudo apt update
sudo apt -y full-upgrade
sudo ufw status  # Ensure the firewall is inactive
```

---

### Time Synchronization

```bash
sudo apt install systemd-timesyncd
sudo timedatectl set-ntp true
sudo timedatectl status  # Verify status
```

---

### Disable Swap

```bash
sudo swapoff -a
sudo sed -i.bak -r 's/(.+ swap .+)/#/' /etc/fstab
free -m  # Confirm swap is disabled
cat /etc/fstab | grep swap
```

---

### Kernel Module Configuration

1. Create a configuration file:

    ```bash
    sudo vim /etc/modules-load.d/k8s.conf
    ```

    Add the following lines:

    ```plaintext
    overlay
    br_netfilter
    ```

2. Load the modules:

    ```bash
    sudo modprobe overlay
    sudo modprobe br_netfilter
    lsmod | grep "overlay\|br_netfilter"  # Verify
    ```

---

### Network Configuration

1. Create a configuration file:

    ```bash
    sudo vim /etc/sysctl.d/k8s.conf
    ```

    Add the following lines:

    ```plaintext
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    net.ipv4.ip_forward = 1
    ```

2. Apply the configuration:

    ```bash
    sudo sysctl --system
    ```

---

### Install Software Tools

```bash
sudo apt-get install -y apt-transport-https ca-certificates curl   gpg gnupg2 software-properties-common
```

---

### Install Kubernetes Tools

1. Add Kubernetes repository and keys:

    ```bash
    sudo mkdir -m 755 /etc/apt/keyrings
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key |       sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' |       sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt update
    sudo apt-get install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl
    ```

---

### Install and Configure Containerd

1. Install Docker and containerd:

    ```bash
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    ```

2. Configure containerd:

    ```bash
    sudo mkdir -p /etc/containerd
    sudo containerd config default | sudo tee /etc/containerd/config.toml
    sudo nano /etc/containerd/config.toml  # Ensure `SystemdCgroup = true`
    ```

3. Restart and enable:

    ```bash
    sudo systemctl restart containerd
    sudo systemctl enable containerd
    systemctl status containerd
    ```

---

### Initialize Control-plane

1. Initialize the cluster:

    ```bash
    sudo kubeadm init       --pod-network-cidr=10.244.0.0/16       --cri-socket unix:///var/run/containerd/containerd.sock       --v=5
    ```

2. Set up kubeconfig:

    ```bash
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```

3. Add network plugin (Calico):

    ```bash
    kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml
    curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml
    nano custom-resources.yaml  # Set `CIDR` to 10.244.0.0/16
    kubectl create -f custom-resources.yaml
    ```

---

### Install Helm

```bash
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install -y helm
```

---

### Install Ingress Controller

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
kubectl create ns ingress-nginx
helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx   --set controller.service.type=NodePort   --set controller.service.nodePorts.http=30080   --set controller.service.nodePorts.https=30443
kubectl edit ingressclass nginx  # Add `ingressclass.kubernetes.io/is-default-class: "true"`
```

---

## Worker-node Setup

Follow similar steps as the Control-plane setup, omitting the `kubeadm init` step. Instead, join the cluster using the join command:

```bash
```

---

## Troubleshooting

- Ensure swap is disabled on all nodes.
- Verify network connectivity between nodes.
- Check logs for `kubelet` and `containerd` for issues.

---

## License

MIT
