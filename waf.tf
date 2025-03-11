resource "aws_wafv2_web_acl" "WafWebAcl" {
  name = "albwaftest"
  scope = "REGIONAL"
  description = "Waf in front of ALB for extra protection"

  default_action {
    allow {
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name = "albwaftest"
    sampled_requests_enabled = true
  }

  rule {
    name = "AWSManagedWafRule1"
    priority = 1
    override_action {
      count {
      }
    }
    statement {
      managed_rule_group_statement {
        name = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "AWSManagedWafRule1"
      sampled_requests_enabled = true
    }
  }
  rule {
    name = "AWSManagedWafRule2"
    priority = 2
    override_action {
      count {
      }
    }
    statement {
      managed_rule_group_statement {
        name = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "AWSManagedWafRule2"
      sampled_requests_enabled = true
    }
  }
  rule {
    name = "AWSManagedWafRule3"
    priority = 3
    override_action {
      count {
      }
    }
    statement {
      managed_rule_group_statement {
        name = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name = "AWSManagedWafRule3"
      sampled_requests_enabled = true
    }
  }
}

resource "aws_wafv2_web_acl_association" "WafWebAclAssociation" {
  resource_arn = aws_lb.ApplicationLoadBalancer.arn
  web_acl_arn = aws_wafv2_web_acl.WafWebAcl.arn
}