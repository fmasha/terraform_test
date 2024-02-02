provider "kubernetes" {
  config_context_cluster   = "minikube"
  config_path = "./.kube/config"
}

resource "kubernetes_namespace" "app-namespace" {
  metadata {
	name = "app-namespace"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-test"
    namespace = kubernetes_namespace.app-namespace.id
    labels = {
      App = "nginx"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          App = "nginx"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "example"

          resources {
            limits = {
              cpu    = var.cpu
              memory = var.memory
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
            }
          }
        }
      }
    }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.app-namespace.id
  }

  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      #node_port   = 30201
      node_port   = var.nport
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

# RBAC

resource "kubernetes_role" "test_role" {
  metadata {
    name = "test-role"
    namespace = "app-namespace"
    }
  

  rule {
    api_groups = ["*"]
    resources = ["pods", "nodes", "ns", "services"]
    verbs = ["get", "create", "list"]
    }
}
  

resource "kubernetes_role_binding" "test_role_binding" {
  metadata {
    name = "test_role_binding"
    namespace = "app-namespace"
    }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "Role"
    name = "test-role"
    }

  subject {
    kind = "User"
    name = "masha"
    api_group = "rbac.authorization.k8s.io"
    }
}
