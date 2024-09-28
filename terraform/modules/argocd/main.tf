provider "kubernetes" {
  host                   = var.cluster_endpoint
  token                  = var.cluster_token
  cluster_ca_certificate = base64decode(var.cluster_certificate)
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    token                  = var.cluster_token
    cluster_ca_certificate = base64decode(var.cluster_certificate)
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "4.5.2"
  namespace = "argocd"
  create_namespace = true

  timeout = 600

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
}

data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = helm_release.argocd.namespace
  }
}