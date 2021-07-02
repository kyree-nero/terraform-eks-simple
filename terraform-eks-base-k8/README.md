
This is a build script for any post k8 config.  

## Ingress controller

The ingress controller will help you deploy by dns name  

## Rbac

The rbac is for any k8 level security  

## Dashboard

The dashboard is for the ui.  To access the ui:  
1. Run this  

    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

1. then kubectl proxy
1. then navigate to this [link](https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.5/aio/deploy/recommended.ya), select token and put in the value you got above

    