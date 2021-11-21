resource "null_resource" "install" {
  provisioner "local-exec" {
    command = <<-EOT
      aws eks --region eu-west-3 update-kubeconfig --name star-app
      git clone https://github.com/Julianius/star-app-gitops.git
      kubectl create namespace argocd
      kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.0/cert-manager.yaml
      helm install -n argocd argocd ./star-app-gitops/charts/argo-cd/
      rm -rf ./star-app-gitops/
      kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
      kubectl create namespace logging
      kubectl create namespace release
      kubectl create namespace dev
      kubectl create namespace stg
      sleep 100
      argocd login --insecure $(kubectl -n argocd get svc argocd-server -o json | jq -r .status.loadBalancer.ingress[0].hostname) --username admin --password $(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
      argocd app create elastic --repo https://github.com/Julianius/star-app-gitops --path charts/elasticsearch --sync-policy automatic --dest-server https://kubernetes.default.svc --dest-namespace logging --values values.yaml --values system.values.yaml
      argocd app create fluentd --repo https://github.com/Julianius/star-app-gitops --path charts/fluentd --sync-policy automatic --dest-server https://kubernetes.default.svc --dest-namespace logging --values values.yaml --values logging.values.yaml
      argocd app create kibana --repo https://github.com/Julianius/star-app-gitops --path charts/kibana --sync-policy automatic --dest-server https://kubernetes.default.svc --dest-namespace logging --values values.yaml
      argocd app create prometheus-grafana --repo https://github.com/Julianius/star-app-gitops --path charts/kube-prometheus-stack --sync-policy automatic --dest-server https://kubernetes.default.svc --dest-namespace default --values values.yaml
      argocd app create nginx-ingress --repo https://github.com/Julianius/star-app-gitops --path charts/ingress-nginx --sync-policy automatic --dest-server https://kubernetes.default.svc --dest-namespace default --values values.yaml --values monitoring.values.yml
      argocd app create mongodb-release --repo https://github.com/Julianius/star-app-gitops --path charts/mongodb --sync-policy automatic --dest-server https://kubernetes.default.svc --dest-namespace release --values values.yaml --values release.values.yml
      argocd app create star-app-release --repo https://github.com/Julianius/star-app-gitops --path charts/app --sync-policy automatic --dest-server https://kubernetes.default.svc --dest-namespace release --values values.yaml --values release.values.yaml
      argocd app create mongodb-dev --repo https://github.com/Julianius/star-app-gitops --path charts/mongodb --sync-policy automatic --dest-server https://kubernetes.default.svc --dest-namespace dev --values values.yaml --values dev.values.yml
      argocd app create star-app-dev --repo https://github.com/Julianius/star-app-gitops --path charts/app --sync-policy automatic --dest-server https://kubernetes.default.svc --dest-namespace dev --values values.yaml --values dev.values.yaml
      argocd app create mongodb-stg --repo https://github.com/Julianius/star-app-gitops --path charts/mongodb --sync-policy automatic --dest-server https://kubernetes.default.svc --dest-namespace stg --values values.yaml --values stg.values.yml
      argocd app create star-app-stg --repo https://github.com/Julianius/star-app-gitops --path charts/app --sync-policy automatic --dest-server https://kubernetes.default.svc --dest-namespace stg --values values.yaml --values stg.values.yaml
    EOT
    working_dir = "${path.module}"
  }
  triggers = {
    build_number = "${timestamp()}"
  }
  depends_on  =   [module.eks]
}