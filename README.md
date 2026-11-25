# DevOps Learning Projects

This repository collects hands-on infrastructure, container, Kubernetes, and shell-scripting labs.

## Projects

| Area | What it demonstrates | Documentation |
|---|---|---|
| Kubernetes | kubeadm cluster setup with containerd, CNI networking, Helm, NGINX Ingress, and an OWASP Juice Shop deployment | [Kubernetes guide](./Kubernetes/README.md) |
| Docker | Build and run a custom Newman CLI image with additional utilities and a reporter | [Docker guide](./Docker/README.md) |
| Bash | Read structured sample records, perform basic email-format checks, validate numeric IDs, and classify odd/even IDs | [Scripting task](./Scripting_task/README.md) |

## Repository layout

```text
.
├── Kubernetes/
│   ├── README.md
│   ├── juice-shop-namespace.yaml
│   ├── juice-shop-deployment.yaml
│   ├── juice-shop-service.yaml
│   └── juice-shop-ingress.yaml
├── Docker/
│   ├── Dockerfile
│   ├── README.md
│   └── build-and-run.sh
└── Scripting_task/
    ├── E-MAIL-SCRIPT.sh
    ├── emails.txt
    └── README.md
```

## Important

These are learning/lab exercises, not production deployment templates. The Juice Shop application is intentionally vulnerable and should only be used in an isolated training environment. Review image versions, resource limits, ingress exposure, and credentials before using any component outside a local lab.

## Validation

Kubernetes manifests can be checked with:

```bash
kubectl apply --dry-run=client -f Kubernetes/juice-shop-namespace.yaml
kubectl apply --dry-run=client -f Kubernetes/juice-shop-deployment.yaml
kubectl apply --dry-run=client -f Kubernetes/juice-shop-service.yaml
kubectl apply --dry-run=client -f Kubernetes/juice-shop-ingress.yaml
```

Build the Docker image from its folder:

```bash
cd Docker
docker build -t newman:local .
docker run --rm newman:local --version
```

Run the Bash exercise from its folder:

```bash
cd Scripting_task
bash E-MAIL-SCRIPT.sh
```
