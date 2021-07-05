
This is a build script for any post k8 config.  

## Ingress controller

The ingress controller will help you deploy by dns name  

## Rbac

The rbac is for any k8 level security  

## Dashboard

The dashboard is for the ui.  I'd like to get this going in helm but for now I'm taking this straight from 

https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml

To access the ui:  

1. Run this  

    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

1. then kubectl proxy
1. then navigate to this [link](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login), select token and put in the value you got above

## Logging

1. Go to the cloud watch console then log &lt; log groups.  You will see a log stream called /eks/diu-eks-cluster/containers.  This currently uses fluentd