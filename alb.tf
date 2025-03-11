# create application load balancer

resource "aws_lb" "ApplicationLoadBalancer" {
  name                       = "Mytestalb"
  load_balancer_type         = "application"
  internal                   = false
  ip_address_type            = "ipv4"
  security_groups            = ["sg-086b05e752f92c7f5"]
  subnets                    = ["subnet-0c1a9d3194d60eb18","subnet-038ca5d4a4fe4a0c9"]
  enable_deletion_protection = false
  idle_timeout               = 60
  desync_mitigation_mode     = "defensive"
  drop_invalid_header_fields = false
  enable_http2               = true
  enable_waf_fail_open       = false

  tags   = {
    Name = "mytestalb"
  }

 access_logs {
   bucket = "my-requestlogs"
   prefix =	"my-app-lb"
   
   }

}

# create target group

resource "aws_lb_target_group" "mytg" {
  name        = "mytg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-08bb60cfaa899c248"
   
health_check {
    enabled             = true
    interval            = 300
    path                = "/health"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }


} 

resource "aws_lb_target_group_attachment" "mytg" {
  target_group_arn = aws_lb_target_group.mytg.arn
  target_id        = aws_instance.Ec2Instance.id
  port = 80
} 

resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn  = aws_lb.ApplicationLoadBalancer.arn
  port               = 443
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-2016-08"
  certificate_arn    = "arn:aws:acm:eu-west-1:340265797154:certificate/bf12af21-62de-4eab-aae2-787a6d1d9215"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mytg.arn
  }

}




