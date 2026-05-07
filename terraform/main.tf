resource "kubernetes_namespace" "devops" {
  metadata {
    name = "suman-devops"
  }
}