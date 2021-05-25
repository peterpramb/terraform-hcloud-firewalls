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
    }
  }

  labels   = each.value.labels
}
