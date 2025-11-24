# Proxmox-lab

My purpose is to simulate fully working small/medium enterprise network - to learn infrastructure things I might miss while doing my everyday chores and to dive deeper into ansible and terraform

## project structure

The whole network is virtualized on Proxmox VE (with some exceptions, e.g. backup machine), with infrastructure managed with Terraform and configuration managed with ansible. 

The host machine is HP Proliant DL380 gen10, with system sitting on 2 mirrored 500GB disks (which is my main constraint)

Terraform files are splitted basing on network segmentation (`dmz.tf`, `clients.tf` etc.) and they contain definitions of VMs and containers in given segment. 

Ansible tasks are ordered in roles, with main `/ansible/site.yml` file, inventory defined in `inventories` dir and secrets stored in ansible vault.

`/scripts` directory contains scripts that run out of terraform or ansible scope.

Packer is used for creating reusable QEMU VM templates

## current systems list

#### Firewall - LAB-S01-FW

Rules defined with `iptables`, network config defined with `netplan`, plays also role of LAN router

#### apt proxy - LAB-S02-Proxy

APT packets downloading HTTP proxy, logs traffic and caches packets. Defined with `squid`, ultimately general HTTP proxy

#### DHCP and DNS - LAB-S03-DHCP_DNS

Defined with `isc-dhcp4-server` and `bind9`. Also hosts local DDNS service assigning dynamically domain names to IP addresses of DHCP clients

#### Root CA - LAB-S04-RootCA

Just RootCA simple as it is
