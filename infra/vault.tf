resource "vault_policy" "server_ro" {
  name   = "server-read"
  policy = <<EOT
  path "secret/servers/common" {
    capabilities = ["read"]
  }
  path "auth/token/renew-self" {
      capabilities = ["update"]
  }
EOT
}

resource "vault_policy" "caddy_ro" {
  name   = "server-read"
  policy = <<EOT
  path "secret/server/caddy" {
    capabilities = ["read"]
  }
EOT
}

variable "influx_token" {
  type        = string
  description = "InfluxDB token for monitoring"
}


resource "vault_kv_secret" "server_common" {
  data_json = jsonencode({
    influx_token = var.influx_token
  })
  path      = "secret/servers/common"
}

variable "hnatekmar_secret_key" {
  type        = string
  description = "Secret key for hnatekmar domain"
}

variable "hnatekmar_api_key" {
  type = string
  description = "Api key for hnatekmar domain"
}
variable "algovector_secret_key" {
  type        = string
  description = "Secret key for algovector domain"
}
variable "algovector_api_key" {
  type        = string
  description = "Api key for algovector domain"
}

resource "vault_kv_secret" "server_caddy" {
  data_json = jsonencode({
    hnatekmar_secret_key = var.hnatekmar_secret_key
    hnatekmar_api_key = var.hnatekmar_api_key
    algovector_secret_key = var.algovector_secret_key
    algovector_api_key = var.algovector_api_key
  })
  path      = "secret/server/caddy"
}