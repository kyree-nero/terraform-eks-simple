data "terraform_remote_state" "kubeconfig" {
    backend = "remote"

    config = {
        organization = "kyree-terraform"
        workspaces = {
            name = "eks-dev"
        }
    }

}