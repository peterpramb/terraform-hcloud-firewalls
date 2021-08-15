[![License](https://img.shields.io/github/license/peterpramb/terraform-hcloud-firewalls)](https://github.com/peterpramb/terraform-hcloud-firewalls/blob/master/LICENSE)
[![Latest Release](https://img.shields.io/github/v/release/peterpramb/terraform-hcloud-firewalls?sort=semver)](https://github.com/peterpramb/terraform-hcloud-firewalls/releases/latest)
[![Terraform Version](https://img.shields.io/badge/terraform-%E2%89%A5%200.13.0-623ce4)](https://www.terraform.io)


# terraform-hcloud-firewalls

[Terraform](https://www.terraform.io) module for managing firewalls in the [Hetzner Cloud](https://www.hetzner.com/cloud).

It implements the following [provider](#providers) resources:

- [hcloud\_firewall](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall)


## Usage

```terraform
module "firewall" {
  source    = "github.com/peterpramb/terraform-hcloud-firewalls?ref=<release>"

  firewalls = [
    {
      name   = "mailserver"
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
          port        = "25"
          remote_ips  = [
            "0.0.0.0/0",
            "::/0"
          ]
          description = "allow SMTP in"
        },
        {
          direction   = "in"
          protocol    = "tcp"
          port        = "143"
          remote_ips  = [
            "0.0.0.0/0",
            "::/0"
          ]
          description = "allow IMAP in"
        },
        {
          direction   = "out"
          protocol    = "icmp"
          port        = null
          remote_ips  = [
            "0.0.0.0/0",
            "::/0"
          ]
          description = "allow ICMP out"
        },
        {
          direction   = "out"
          protocol    = "tcp"
          port        = "25"
          remote_ips  = [
            "0.0.0.0/0",
            "::/0"
          ]
          description = "allow SMTP out"
        },
        {
          direction   = "out"
          protocol    = "tcp"
          port        = "53"
          remote_ips  = [
            "0.0.0.0/0",
            "::/0"
          ]
          description = "allow DNS out"
        },
        {
          direction   = "out"
          protocol    = "udp"
          port        = "53"
          remote_ips  = [
            "0.0.0.0/0",
            "::/0"
          ]
          description = "allow DNS out"
        }
      ]
      labels = {
        "managed"    = "true"
        "managed_by" = "Terraform"
      }
    }
  ]
}
```


## Requirements

| Name | Version |
|------|---------|
| [terraform](https://www.terraform.io) | &ge; 0.13 |


## Providers

| Name | Version |
|------|---------|
| [hcloud](https://registry.terraform.io/providers/hetznercloud/hcloud) | &ge; 1.28 |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| firewalls | List of firewall objects to be managed. | list(map([*firewall*](#firewall))) | See [below](#defaults) | yes |


#### *firewall*

| Name | Description | Type | Required |
|------|-------------|:----:|:--------:|
| [name](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall#name) | Unique name of the firewall. | string | yes |
| rules | List of firewall rule objects. | list(map([*rule*](#rule))) | no |
| [labels](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall#labels) | Map of user-defined labels. | map(string) | no |


#### *rule*

| Name | Description | Type | Required |
|------|-------------|:----:|:--------:|
| [direction](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall#direction) | Traffic direction to apply this firewall rule to. | string | yes |
| [protocol](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall#protocol) | Protocol to match with this firewall rule. | string | yes |
| [port](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall#port) | Port(range) to match with this firewall rule. | string | yes (TCP/UDP only) |
| [remote\_ips](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall#source_ips) | List of remote IPs to match with this firewall rule. | list(string) | yes |
| [description](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall#description) | Description of this firewall rule. | string | no |


### Defaults

```terraform
firewalls = [
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
    labels = {}
  }
]
```


## Outputs

| Name | Description |
|------|-------------|
| firewalls | List of all firewall objects. |
| firewall\_ids | Map of all firewall objects indexed by ID. |
| firewall\_names | Map of all firewall objects indexed by name. |


### Defaults

```terraform
firewalls = [
  {
    "id" = "49002"
    "name" = "firewall-1"
    "rule" = [
      {
        "description" = "allow ICMP in"
        "destination_ips" = []
        "direction" = "in"
        "port" = ""
        "protocol" = "icmp"
        "source_ips" = [
          "0.0.0.0/0",
          "::/0",
        ]
      },
      {
        "description" = "allow SSH in"
        "destination_ips" = []
        "direction" = "in"
        "port" = "22"
        "protocol" = "tcp"
        "source_ips" = [
          "0.0.0.0/0",
          "::/0",
        ]
      },
    ]
  },
]

firewall_ids = {
  "49002" = {
    "id" = "49002"
    "name" = "firewall-1"
    "rule" = [
      {
        "description" = "allow ICMP in"
        "destination_ips" = []
        "direction" = "in"
        "port" = ""
        "protocol" = "icmp"
        "source_ips" = [
          "0.0.0.0/0",
          "::/0",
        ]
      },
      {
        "description" = "allow SSH in"
        "destination_ips" = []
        "direction" = "in"
        "port" = "22"
        "protocol" = "tcp"
        "source_ips" = [
          "0.0.0.0/0",
          "::/0",
        ]
      },
    ]
  }
}

firewall_names = {
  "firewall-1" = {
    "id" = "49002"
    "name" = "firewall-1"
    "rule" = [
      {
        "description" = "allow ICMP in"
        "destination_ips" = []
        "direction" = "in"
        "port" = ""
        "protocol" = "icmp"
        "source_ips" = [
          "0.0.0.0/0",
          "::/0",
        ]
      },
      {
        "description" = "allow SSH in"
        "destination_ips" = []
        "direction" = "in"
        "port" = "22"
        "protocol" = "tcp"
        "source_ips" = [
          "0.0.0.0/0",
          "::/0",
        ]
      },
    ]
  }
}
```


## License

This module is released under the [MIT](https://github.com/peterpramb/terraform-hcloud-firewalls/blob/master/LICENSE) License.
