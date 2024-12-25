resource "porkbun_dns_record" "ingress" {
  domain = "hnatekmar.xyz"
  name = "*"
  content = "78.80.33.35"
  type   = "A"
}