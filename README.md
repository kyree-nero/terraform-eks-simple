# Terraform EKS sample 

Here is a terraform eks example.  

There are three projects.... 

1. terraform-eks-base -- deploys all the aws stuff you need  
1. terraform-eks-base-k8 -- deploys all the k8 stuff you need on top of aws  
1. terraform-eks-helm -- deploys what would be the app on top of that  

The chart that is set to deploy will put nginx out on port 80  

Steps to run the app...  

1. cd terraform-eks-base
1. add host ip cidr block to terraform.tfVars
1. run terraform apply --auto-approve
1. run cd ../terraform-eks-base-k8
1. run terraform apply --auto-approve
1. run the export command output as part of the last command to connect directly to the kube instance in your terminal
1. run cd ../terraform-eks-helm
1. run terraform apply --auto-approve
1. test it by running   
    curl -I -H "Host: app1.xyz.com" $(kubectl get services -n ingress | grep ingress | grep LoadBalancer | awk -F '  +' '{print $4}')

You should see  ... 


    HTTP/1.1 200 OK
    Date: Wed, 23 Jun 2021 17:58:11 GMT
    Content-Type: text/html
    Content-Length: 612
    Connection: keep-alive
    Last-Modified: Tue, 04 Dec 2018 14:44:49 GMT
    ETag: "5c0692e1-264"
    Accept-Ranges: bytes