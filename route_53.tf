resource "aws_route53_zone" "main" {
  name = "sulimannn.com"
}

resource "aws_route53_record" "atlantis" {
  #for_each =  {
  #    for dvo in aws_acm_certificate.cert.domain_validation_options: dvo.domain_name => {
  #    name   = dvo.resource_record_name
  #    record = dvo.resource_record_value
  #    type   = dvo.resource_record_type
  #    }
  #} 
  allow_overwrite = true
  zone_id = "${aws_route53_zone.main.zone_id}"
  name = "atlantis.sulimann.com"
  type = "A"
  ttl = "300"
  records = [ aws_eip.eip.public_ip ]
}

#resource "aws_acm_certificate" "cert" {
#  domain_name = "sulimann.com"
#  validation_method = "DNS"
#}

#resource "aws_acm_certificate_validation" "name" {
#  certificate_arn = "${aws_acm_certificate.cert.arn}"
#  validation_record_fqdns = [ for record in aws_route53_record.atlantis : record.fqdn]
#}
