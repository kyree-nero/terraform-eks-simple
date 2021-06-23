Here is a terraform eks example.  There is a helm example as well driven by terraform.  

The chart that is set to deploy will put nginx out on port 80

Do this

1. cd terraform-eks-base
1. add host ip cidr block to terraform.tfVars
1. run terraform apply --auto-approve
1. run cd ../terraform-eks-base-k8
1. run terraform apply --auto-approve
1. run the export command output as part of the last command to connect directly to the kube instance in your terminal
1. to get the LBHOST run...  kubectl get services | grep ingress | grep LoadBalancer | awk -F '  +' '{print $4}'
Note that it may take some time for the host to do what it needs to to show up.   Give it a minute if it doesn't automatically show up.
1. run cd ../terraform-eks-helm
1. update helm-charts/simple-ingress-by-prefix/templates/app-ingress.yaml > host to the value you just ouput in the terminal
1. run terraform apply --auto-approve
1. test it by running curl &lt;LBHOST&gt;/app1

