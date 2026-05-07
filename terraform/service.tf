resource "kubernetes_service" "suman_service" {
  metadata {
    name      = "suman-devops-service"
    namespace = kubernetes_namespace.devops.metadata[0].name
  }

  spec {
    selector = {
      app = "suman-devops"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}