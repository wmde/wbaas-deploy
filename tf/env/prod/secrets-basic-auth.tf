module "basic-auth" {
  source  = "github.com/wbstack/terraform-kubernetes-basic-auth?ref=9db7c6db223ee08dfd4652b7e2945cde856195ab"
  providers = {
    kubernetes = kubernetes.wbaas-3
  }
  name = "basic-auth"
  namespace = "default"
}