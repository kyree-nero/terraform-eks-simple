
This is a build script for any post k8 config.  

## Ingress controller

The ingress controller will help you deploy by dns name  

## Rbac

The rbac is for any k8 level security  

## Dashboard

### kubernetes-ui
The dashboard is for the ui.  It is the simplest kubernetes dashboard.  I'd like to get this going in helm but for now I'm taking this straight from 

https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml

To access the ui:  

1. Run this  

    kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

1. then kubectl proxy
1. then navigate to this [link](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login), select token and put in the value you got above



## Logging

Configurable in the terraform variables, logging can be...    
* off
* fluentd
* fluent-bit

### fluentd

1. Go to the cloud watch console then log &lt; log groups.  You will see a log stream called /eks/diu-eks-cluster/containers.  This currently uses fluentd

### fluent-bit

1. Run kubectl logs ds/fluentbit.  You shouldn't see any errors.   
1. Go to firehose and look for the delivery stream called eks-stream.  It will update with new log files periodically.

Additional reading https://aws.amazon.com/blogs/opensource/centralized-container-logging-fluent-bit/

## Monitoring

Monitoring can be done with aws tooling or native kubernetes.   The aws solution application relies on fluentd (logging) while the native kubernetes solution relies on prometheus and grafana.  Either way you get real time dashboard into your metrics.   Monitoring can be enabled or disabled in terraform variables (Look for monitoring_enabled [true|false]).   The choices for monitoring type are container-insights or prometheus.   

### kubernetes native

### kube-metrics

Kube-metrics gathers all the metrics from your containers

### prometheus 

Promethesus serves your data within your cluster.  It just doesn't serve it in a human consumable format because there are so many datapoints, etc.  

To see some prometheus data... 

1. port forward prometheus' pod to your local machine
    
    kubectl get pods -n prometheus
    kubectl port-forward prometheus-community-server-..   8080:9090 -n prometheus

1. navigate to the exposed port on your local machine and use the lower right hand corner of the search box to select some data as its captured.

### grafana 

Grafana consumes the prometheus data to show the dash board

To the see the dashboard

1. Grab the exposed service endpoint with  

    kubectl get svc -n grafana | grep LoadBalancer | awk -F '  +' '{print $4}' 

1. navigate to that link in a browser window
1. log in with admin,Password
1. set the datasource to the only choice available (prometheus)
1. Go to create > import and type 3119 (a preconfigured ots dashboard)...then import
1. A dashboard with some metrics will appear.  its highly configurable.  You can make your own dashboards too.  A deep dive into customizing the dashboard and getting familiar w/ grafana is probably a good idea as you probe deeper.

### aws container insights

This is for use with fluentd.  It lays in its own cloudwatch metric originating pod(s) in the cluster, which can be displayed in cloudwatch.  See Cloudwatch &gt; Container Insights &gt; Performance Monitoring for the dashboard.

<https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-view-metrics.html>
