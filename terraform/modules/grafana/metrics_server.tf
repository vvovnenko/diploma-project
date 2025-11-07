resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"

  values = [yamlencode({
    args = [
      "--kubelet-preferred-address-types=InternalIP,Hostname,ExternalIP",
      "--kubelet-use-node-status-port",
      # "--kubelet-insecure-tls=true",
    ]
    tolerations = [{ key = "CriticalAddonsOnly", operator = "Exists" }]
    podAnnotations = { "cluster.autoscaler.kubernetes.io/safe-to-evict" = "true" }
  })]
}
