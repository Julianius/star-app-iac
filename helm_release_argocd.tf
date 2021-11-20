/*
resource "helm_release" "argocd" {
  name             = "argocd"
  chart            = "argo-cd"
  repository       = "./charts"
  namespace        = "argocd"
  create_namespace = true
  wait             = true
  reset_values     = true
  max_history      = 3
}
*/