Here is a terraform eks example.  There is a helm example as well driven by terraform.  

The chart that is set to deploy will put nginx out on port 80

Do this

    kubectl get service/app-service |  awk {'print " " $4  '} | column -t  

...then do a curl to that address

curl &lt; external ip &gt;:80  

Note that it may take some time for the host to do what it needs to to work.