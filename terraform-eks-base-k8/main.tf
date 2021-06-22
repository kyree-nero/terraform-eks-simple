

/*
resource "helm_release" "ingress" {
  name       = "nginx-ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  version    = "0.7.1"
  
}
*/

resource "helm_release" "ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  #version =  "3.15.2"
  version =  "3.33.0"
}







# resource "aws_lb" "eks_load_balancer" {
#     name = "eks-load-balancer"
#     subnets = var.public_subnets
#     security_groups = [var.public_security_group]
#     idle_timeout = 400
# }

# resource "aws_lb_target_group" "eks_target_group" {
#     name = "eks-load-balancer-${substr(uuid(), 0, 3)}"
#     port = var.target_group_port
#     protocol = var.target_protocol
#     vpc_id = var.vpc_id

#     lifecycle {
#         ignore_changes = [name]
#         create_before_destroy = true
#     }

#     health_check {
#       healthy_threshold = var.lb_healthy_threshold
#       unhealthy_threshold =  var.lb_healthy_threshold
#       timeout = var.lb_timeout
#       interval = var.lb_interval
#     }
# }

# resource "aws_lb_listener" "eks_lb_listener" {
#     load_balancer_arn =  aws_lb.eks_load_balancer.arn
#     port = var.listener_port
#     protocol = var.listener_protocol
#     default_action {
#       type = "forward"
#       target_group_arn = aws_lb_target_group.eks_target_group.arn
#     }
# }

# resource "aws_lb_target_group_attachment" "eks_target_group_attach" {
#     #count = var.instance_count
#     target_group_arn = aws_lb_target_group.eks_target_group.arn
#     target_id = aws_instance.myk3_node[count.index].id
#     port = var.target_group_port
# }




