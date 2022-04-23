# =====================================
# Manage firewalls in the Hetzner Cloud
# =====================================


# ------------
# Local Values
# ------------

locals {
  output_firewalls   = [
    for name, firewall in hcloud_firewall.firewalls : merge(firewall, {
      "apply_to"   = null
      "attachment" = try(hcloud_firewall_attachment.attachments[name], {})
    })
  ]

  output_attachments = [
    for name, attachment in hcloud_firewall_attachment.attachments :
      merge(attachment, {
        "name"          = name
        "firewall_name" = try(local.attachments[name].firewall, null)
      })
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

output "firewall_attachments" {
  description = "A list of all firewall attachment objects."
  value       = local.output_attachments
}

output "firewall_attachment_ids" {
  description = "A map of all firewall attachment objects indexed by ID."
  value       = {
    for attachment in local.output_attachments : attachment.id => attachment
  }
}

output "firewall_attachment_names" {
  description = "A map of all firewall attachment objects indexed by name."
  value       = {
    for attachment in local.output_attachments : attachment.name => attachment
  }
}
