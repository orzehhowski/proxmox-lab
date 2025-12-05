# Proxmox-lab

My purpose is to simulate fully working small/medium enterprise network - to learn infrastructure tweaks I might miss while doing my everyday chores and to dive deeper into ansible and terraform

I do not use many of proxmox built-in features mainly beacuse I want to keep configuration in ansible and I'm focusing more on implementing stuff in linux instead of using seamless solutions that are offered by proxmox VE

## project structure

The whole network is virtualized on Proxmox VE (with some exceptions, e.g. backup machine), with infrastructure managed with Terraform and configuration managed with ansible. 

The host machine is HP Proliant DL380 gen10, with system sitting on 2 mirrored 500GB disks (which is my main constraint)

Terraform files are splitted basing on network segmentation (`dmz.tf`, `clients.tf` etc.) and they contain definitions of VMs and containers in given segment. 

Ansible tasks are ordered in roles, with main `/ansible/site.yml` file, inventory defined in `inventories` dir and secrets stored in ansible vault. All vault variables contain `vault_` prefix, which is removed in `/group_vars/all/main.yml`, so in this file you can find all vault variables required by the inventory. Full environment configuration can be started with:

`ansible-playbook -i ./inventories/prod/inventory.yml --vault-password-file ./vault_password site.yml`

I decided to separate PX host specific ansible configuration from VMs/containers configs, so I put it in `/ansible/px-host-playbook.yml` - no roles, all config in one file. `Proxmoxer` python package is required in your local ansible environment for this playbook. You can run it with this command in `/ansible` dir (px host root password is required):

`ansible-playbook --inventory ./inventories/prod/inventory.yml --vault-password-file ./vault_password --ask-become-pass px-host-playbook.yml`

In order to run particular machine configuration, use tag with it's numer (e.g. `--tags lab-s01`). For details check `/ansible/site.yml`

## current systems list

(For configuration insights visit `ansible/site.yml` and individual roles definitions)

#### Firewall - LAB-S01-FW

Rules defined with `iptables`, network config defined with `netplan`, plays also role of LAN router

#### apt proxy - LAB-S02-Proxy

APT packets downloading HTTP proxy, logs traffic and caches packets. Defined with `squid`, ultimately general HTTP proxy

#### DHCP and DNS - LAB-S03-DHCP_DNS

Defined with `isc-dhcp4-server` and `bind9`. Also hosts local DDNS service assigning dynamically domain names to IP addresses of DHCP clients

#### Root CA - LAB-S04-RootCA

Just RootCA simple as it is

#### Data - LAB-S05-Data

NFS and SQL server.

#### Apps hosts - LAB-S11-Apps and LAB-S12-Apps-HA

These are QEMU Ubuntu VMs that hosts Docker containers with internal apps - in active-active or active-passive HA clusters - depending on app specifications
