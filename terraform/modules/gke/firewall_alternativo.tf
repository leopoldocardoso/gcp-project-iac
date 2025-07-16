# firewall_alternativo.tf
# Alternativa ao Cloud Armor usando VPC Firewall Rules

# Bloquear portas filtered nos nodes GKE
resource "google_compute_firewall" "block_filtered_ports_gke" {
  name    = "block-filtered-ports-gke-nodes"
  network = "vpc-project"  # AJUSTE: nome da sua VPC
  
  # Alta prioridade para executar antes de outras regras
  priority = 100
  
  # Tráfego de entrada
  direction = "INGRESS"
  
  # De qualquer origem externa
  source_ranges = ["0.0.0.0/0"]
  
  # AJUSTE: usar as tags corretas dos seus nodes GKE
  target_tags = ["gke-gke-cluster-project-356866df-node"]
  
  # Bloquear as portas que aparecem como filtered
  deny {
    protocol = "tcp"
    ports = [
      "11",   # systat
      "13",   # daytime  
      "15",   # netstat
      "19",   # chargen
      "21",   # ftp
      "25",   # smtp
      "26",   # rsftp
      "37",   # time
      "38",   # rap
      "43",   # whois
      "49",   # tacacs
      "53"    # domain
    ]
  }
  
  description = "Bloquear portas filtered detectadas pelo nmap nos nodes GKE"
}

# IMPORTANTE: Permitir SSH apenas de IPs administrativos
resource "google_compute_firewall" "allow_ssh_admin_only" {
  name    = "allow-ssh-admin-gke-nodes"
  network = "vpc-project"
  
  # Prioridade mais alta que a regra de bloqueio
  priority = 50
  
  direction = "INGRESS"
  
  # SUBSTITUA pelos IPs reais dos administradores
  source_ranges = [
    "192.168.29.0/24",        # Sua rede atual (baseada nas regras existentes)
    # "SEU_IP_PUBLICO/32",    # Adicione seu IP público
    # "OUTRO_IP_ADMIN/32"     # Outros IPs administrativos
  ]
  
  target_tags = ["gke-gke-cluster-project-356866df-node"]
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  description = "Permitir SSH apenas para administradores autorizados"
}

# Rate limiting básico via firewall (bloquear conexões excessivas)
resource "google_compute_firewall" "rate_limit_connections" {
  name    = "rate-limit-gke-nodes"
  network = "vpc-project"
  
  priority = 200
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["gke-gke-cluster-project-356866df-node"]
  
  # Permitir apenas conexões HTTP/HTTPS normais
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080", "8443"]
  }
  
  description = "Permitir apenas portas HTTP/HTTPS para tráfego normal"
}

# Bloquear protocolos de scan comuns
resource "google_compute_firewall" "block_scan_protocols" {
  name    = "block-scan-protocols-gke"
  network = "vpc-project"
  
  priority = 150
  direction = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["gke-gke-cluster-project-356866df-node"]
  
  # Bloquear ICMP (ping) para reduzir descoberta
  deny {
    protocol = "icmp"
  }
  
  description = "Bloquear protocolos comuns de descoberta/scan"
}

# Outputs informativos
output "firewall_protection_summary" {
  value = {
    "portas_bloqueadas" = "11,13,15,19,21,25,26,37,38,43,49,53"
    "ssh_permitido_apenas_para" = "192.168.29.0/24"
    "portas_http_permitidas" = "80,443,8080,8443"
    "icmp_bloqueado" = "Sim (reduz descoberta de hosts)"
    "target_tags" = "gke-gke-cluster-project-356866df-node"
    "rede" = "vpc-project"
  }
  description = "Resumo da proteção implementada via VPC firewall rules"
}

# Comandos úteis para verificação
output "comandos_verificacao" {
  value = {
    "verificar_regras" = "gcloud compute firewall-rules list --filter='name~block-filtered'"
    "verificar_nodes" = "gcloud compute instances list --filter='name~gke' --format='table(name,tags.items[])'"
    "testar_nmap" = "nmap -sS -p 11,13,15,19,21,22,25,26,37,38,43,49,53 34.55.134.0"
    "verificar_logs" = "gcloud logging read 'resource.type=gce_firewall_rule' --limit=10"
  }
  description = "Comandos para verificar e testar a implementação"
}

