# These are machines in DMZ network subnet - 10.120.69.0/28

resource "proxmox_lxc" "LAB-S03-DHCP-DNS" {
  vmid        = 102
  target_node = var.node
  hostname = "LAB-S03-DHCP-DNS"
  ostemplate = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  ostype = "ubuntu"
  password = var.recovery_password
  ssh_public_keys = var.ssh_public_key

  memory = 1024
  cores = 2
  swap = 512

  bwlimit = 0
  cmode = "tty"
  restore = false
  force = false
  ignore_unpack_errors = false
  start = true
  template = false
  unique = false
  unprivileged = true

  rootfs {
    acl = false
    quota = false 
    replicate = false
    ro = false
    shared = false
    size = "8G"
    storage = "TestDir"
  }

  network {
    name   = "eth0"
    bridge = "vmbr1"
    ip     = "10.120.69.18/28"
    gw     = "10.120.69.17"
  }
}