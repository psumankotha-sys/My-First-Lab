resource "kubernetes_deployment" "suman_app" {
  metadata {
    name      = "suman-devops"
    namespace = kubernetes_namespace.devops.metadata[0].name
    labels = {
      app = "suman-devops"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "suman-devops"
      }
    }

    template {
      metadata {
        labels = {
          app = "suman-devops"
        }
      }

      spec {
        container {
          name  = "suman-devops"
          image = "sumankotha/suman-devops:v2"

          port {
            container_port = 80
          }

          env {
            name  = "APP_NAME"
            value = "Suman DevOps"
          }
        }
      }
    }
  }
}