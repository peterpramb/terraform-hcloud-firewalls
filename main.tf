# =====================================
# Manage firewalls in the Hetzner Cloud
# =====================================


# ------------
# Local Values
# ------------

locals {
  # Build a map of all provided firewall objects, indexed by firewall name:
  firewalls = {
    for firewall in var.firewalls : firewall.name => firewall
  }

  # Build a map of all provided firewall objects to be attached, indexed
  # by firewall name:
  attachments = {
    for firewall in var.firewalls : firewall.name => merge(firewall, {
      "firewall" = firewall.name
    }) if(try(firewall.server, null) != null)
  }
}


# ---------
# Firewalls
# ---------

resource "hcloud_firewall" "firewalls" {
  for_each = local.firewalls

  name     = each.value.name

  dynamic "rule" {
    for_each          = each.value.rules

    content {
      direction       = rule.value["direction"]
      protocol        = rule.value["protocol"]
      port            = (rule.value["protocol"] == "tcp" ||
                         rule.value["protocol"] == "udp"  ?
                         rule.value["port"] : null)
      source_ips      = (rule.value["direction"] == "in"  ?
                         rule.value["remote_ips"] : null)
      destination_ips = (rule.value["direction"] == "out" ?
                         rule.value["remote_ips"] : null)
      description     = rule.value["description"]
    }
  }

  labels   = each.value.labels
}


# --------------------
# Firewall Attachments
# --------------------

resource "hcloud_firewall_attachment" "attachments" {
  for_each        = local.attachments

  firewall_id     = hcloud_firewall.firewalls[each.value.name].id
  label_selectors = each.value.server.labels
  server_ids      = each.value.server.ids
}
