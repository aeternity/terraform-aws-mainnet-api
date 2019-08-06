resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain
  subject_alternative_names = [var.domain_alias]
  validation_method         = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  zone_id = "${var.dns_zone}"
  name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    aws_route53_record.cert_validation.fqdn,
    # trim last dot as it's DNS record name
    substr(
      aws_acm_certificate.cert.domain_validation_options.1.resource_record_name,
      0,
      length(aws_acm_certificate.cert.domain_validation_options.1.resource_record_name) - 1
    )
  ]
}
