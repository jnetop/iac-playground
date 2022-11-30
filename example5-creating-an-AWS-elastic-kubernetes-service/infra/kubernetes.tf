resource "kubernetes_deployment" "dotnet-webapp" {
  metadata {
    name = "dotnet-webapp"
    labels = {
      nome = "dotnet"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        nome = "dotnet"
      }
    }

    template {
      metadata {
        labels = {
          nome = "dotnet"
        }
      }

      spec {
        container {
          image = "265776556430.dkr.ecr.us-west-2.amazonaws.com/production:V1"
          name  = "dotnet"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "loadbalancer" {
  metadata {
    name = "load-balancer-dotnet-webapp"
  }
  spec {
    selector = {
      nome = "dotnet"
    }
    port {
      port = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
}

# data "kubernetes_service" "DNS" {
#     metadata {
#       name = "load-balancer-dotnet-webapp"
#     }
# }

# output "DNS" {
#   value = data.kubernetes_service.DNS.status
# }