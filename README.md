Here is a terraform eks example.  There is a helm example as well driven by terraform.  

The chart that is set to deploy will put nginx out on port 8000.  
Do kubectl get services -o yaml to get the host ... then hit &lt;host&gt;:8000  