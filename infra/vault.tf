resource "vault_policy" "server_ro" {
  name   = "server-read"
  policy = <<EOT
  path "secret/servers/common" {
    capabilities = ["read"]
  }
EOT
}
