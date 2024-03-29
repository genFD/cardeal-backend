# ###############################################################
#                     # DNS #                                   #
#            --------------------------------                   #
# Resources                         Name             Number     #
# ---------                      | -------        |  ------     #
# aws_route53_zone               |  bastion       |   1         #
# aws_acm_certificate            |  cert          |     
# aws_route53_record             |cert_validation |
# aws_acm_certificate_validation |cert            |
# ###############################################################
# Data                  Name             Number                 #
# ---------           | -------        | ------                 #
# Aws ami             |  amazon_linux  |   1                    #
#                     |                |                        #
##################################################################

resource "aws_route53_zone" "primary" {
  name = var.dns_zone_name
}

data "aws_route53_zone" "zone" {
  name = "${var.dns_zone_name}."
}
resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${lookup(var.subdomain, terraform.workspace)}.${data.aws_route53_zone.zone.name}"
  type    = "CNAME"
  ttl     = "300"

  records = [aws_lb.api.dns_name]
}

resource "aws_acm_certificate" "cert" {
  domain_name       = aws_route53_record.app.fqdn
  validation_method = "DNS"

  tags = {
    Name = "${var.prefix}-certificate"
  }

  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_route53_record" "cert_validation" {
  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.zone.zone_id
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]

  ttl = "60"
}




resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}