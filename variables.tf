# =====================================
# Manage firewalls in the Hetzner Cloud
# =====================================


# ---------------
# Input Variables
# ---------------

variable "firewalls" {
  description = "The list of firewall objects to be managed. Each firewall object supports the following parameters: 'name' (string, required), 'rules' (list of rule objects, optional), 'server' (server object, optional), 'labels' (map of KV pairs, optional). Each rule object supports the following parameters: 'direction' (string, required), 'protocol' (string, required), 'port' (string, required for TCP/UDP), 'remote_ips' (list of IP addresses, required), 'description' (string, optional). The server object supports the following parameters: 'ids' (list of server IDs, optional), 'labels' (list of label selectors, optional)."

  type        = list(
    object({
      name   = string
      rules  = list(
        object({
          direction   = string
          protocol    = string
          port        = string
          remote_ips  = list(string)
          description = string
        })
      )
      server = object({
        ids    = list(string)
        labels = list(string)
      })
      labels = map(string)
    })
  )

  default     = [
    {
      name   = "firewall-1"
      rules  = [
        {
          direction   = "in"
          protocol    = "icmp"
          port        = null
          remote_ips  = [
            "0.0.0.0/0",
            "::/0"
          ]
          description = "allow ICMP in"
        },
        {
          direction   = "in"
          protocol    = "tcp"
          port        = "22"
          remote_ips  = [
            "0.0.0.0/0",
            "::/0"
          ]
          description = "allow SSH in"
        }
      ]
      server = null
      labels = {}
    }
  ]

  validation {
    condition     = can([
      for firewall in var.firewalls : regex("\\w+", firewall.name)
    ])
    error_message = "All firewalls must have a valid 'name' attribute specified."
  }

  validation {
    condition     = can([
      for firewall in var.firewalls : [
        for rule in firewall.rules : regex("\\w+", rule.direction)
      ] if lookup(firewall, "rules", null) != null
    ])
    error_message = "All firewall rules must have a valid 'direction' attribute specified."
  }

  validation {
    condition     = can([
      for firewall in var.firewalls : [
        for rule in firewall.rules : regex("\\w+", rule.protocol)
      ] if lookup(firewall, "rules", null) != null
    ])
    error_message = "All firewall rules must have a valid 'protocol' attribute specified."
  }

  validation {
    condition     = can([
      for firewall in var.firewalls : [
        for rule in firewall.rules : regex("\\w+", rule.port)
          if(rule.protocol == "tcp" || rule.protocol == "udp")
      ] if lookup(firewall, "rules", null) != null
    ])
    error_message = "All TCP/UDP firewall rules must have a valid 'port' attribute specified."
  }

  validation {
    condition     = can([
      for firewall in var.firewalls : [
        for rule in firewall.rules : element(rule.remote_ips, 0)
      ] if lookup(firewall, "rules", null) != null
    ])
    error_message = "All firewall rules must have at least one remote IP specified."
  }

  validation {
    condition     = can([
      for firewall in var.firewalls : [
        for rule in firewall.rules : [
          for remote_ip in rule.remote_ips: regex("\\w+", remote_ip)
        ]
      ] if lookup(firewall, "rules", null) != null
    ])
    error_message = "All firewall rules must have valid remote IPs specified."
  }
}
