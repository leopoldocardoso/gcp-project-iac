resource "google_compute_security_policy" "wacl_gke_cluster" {
  name        = "wacl-gke-cluster-project"
  description = "WAF ACL for GKE Simbi - Versão simplificada para bloquear portas filtered"

  # REGRA 1: Bloquear nmap especificamente (1 expressão apenas)
  rule {
    action   = "deny(403)"
    priority = "50"
    match {
      expr {
        expression = "has(request.headers['user-agent']) && request.headers['user-agent'].contains('nmap')"
      }
    }
    description = "Bloquear nmap especificamente"
  }

  # REGRA 2: Bloquear portas críticas - GRUPO 1 (4 expressões)
  rule {
    action   = "deny(403)"
    priority = "60"
    match {
      expr {
        expression = <<-EOT
          has(request.headers['host']) && (
            request.headers['host'].contains(':22') ||
            request.headers['host'].contains(':21') ||
            request.headers['host'].contains(':53') ||
            request.headers['host'].contains(':25')
          )
        EOT
      }
    }
    description = "Bloquear portas críticas SSH, FTP, DNS, SMTP"
  }

  # REGRA 3: Bloquear portas de serviços - GRUPO 2 (4 expressões)
  rule {
    action   = "deny(403)"
    priority = "61"
    match {
      expr {
        expression = <<-EOT
          has(request.headers['host']) && (
            request.headers['host'].contains(':11') ||
            request.headers['host'].contains(':13') ||
            request.headers['host'].contains(':43') ||
            request.headers['host'].contains(':49')
          )
        EOT
      }
    }
    description = "Bloquear portas de serviços systat, daytime, whois, tacacs"
  }

  # REGRA 4: Bloquear User-Agents vazios (1 expressão)
  rule {
    action   = "deny(403)"
    priority = "70"
    match {
      expr {
        expression = "!has(request.headers['user-agent'])"
      }
    }
    description = "Bloquear requests sem User-Agent"
  }

  # Rate limiting mais agressivo para prevenir port scans
  rule {
    action   = "rate_based_ban"
    priority = "100"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    rate_limit_options {
      conform_action = "allow"
      exceed_action  = "deny(429)"
      enforce_on_key = "IP"
      rate_limit_threshold {
        count        = 30   # Mais agressivo: 30 requests por minuto
        interval_sec = 60   
      }
      ban_duration_sec = 900  # 15 minutos de ban
    }
    description = "Rate limiting agressivo contra port scans"
  }

  # SQL Injection (mantido do original)
  rule {
    action   = "deny(403)"
    priority = "200"
    match {
      expr {
        expression = "evaluatePreconfiguredWaf('sqli-v33-stable')"
      }
    }
    description = "SQL injection protection"
  }

  # Linux attacks (mantido do original)
  rule {
    action   = "deny(403)"
    priority = "300"
    match {
      expr {
        expression = "evaluatePreconfiguredWaf('lfi-v33-stable')"
      }
    }
    description = "Linux attack protection"
  }

  # Default allow (mantido do original)
  rule {
    action   = "allow"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default allow"
  }

  # Proteção adaptativa (mantida do original)
  adaptive_protection_config {
    layer_7_ddos_defense_config {
      enable          = true
      rule_visibility = "STANDARD"
    }
  }
}

output "security_policy_name" {
  value = google_compute_security_policy.wacl_gke_cluster.name
}

output "security_policy_id" {
  value = google_compute_security_policy.wacl_gke_cluster.id
}

# OUTPUT: Informações sobre as regras simplificadas
output "regras_anti_port_scan_simples" {
  value = {
    "nmap_bloqueado" = "Sim - detecção por User-Agent"
    "portas_criticas_bloqueadas" = "22 (SSH), 21 (FTP), 53 (DNS), 25 (SMTP)"
    "portas_servicos_bloqueadas" = "11 (systat), 13 (daytime), 43 (whois), 49 (tacacs)"
    "user_agent_vazio_bloqueado" = "Sim"
    "rate_limit" = "30 requests por minuto"
    "ban_duration" = "15 minutos"
    "total_regras" = "7 regras + rate limiting + proteções OWASP"
    "expressoes_por_regra" = "Máximo 4 expressões (dentro do limite de 5)"
  }
  description = "Resumo das proteções simplificadas implementadas"
}

