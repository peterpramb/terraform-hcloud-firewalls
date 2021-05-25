# =====================================
# Manage firewalls in the Hetzner Cloud
# =====================================


# ------------
# Local Values
# ------------

locals {
  output_firewalls = [
    for firewall in hcloud_firewall.firewalls : firewall
  ]
}


# -------------
# Output Values
# -------------

output "firewalls" {
  description = "A list of all firewall objects."
  value       = local.output_firewalls
}

output "firewall_ids" {
  description = "A map of all firewall objects indexed by ID."
  value       = {
    for firewall in local.output_firewalls : firewall.id => firewall
  }
}

output "firewall_names" {
  description = "A map of all firewall objects indexed by name."
  value       = {
    for firewall in local.output_firewalls : firewall.name => firewall
  }
}
