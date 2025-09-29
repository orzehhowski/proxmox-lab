resource "proxmox_lxc" "LAB-S01-FW" {
  vmid        = 100
  target_node = var.node
  hostname = "LAB-S01-FW"
  ostemplate = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  ostype = "ubuntu"
  password = var.recovery_password
  ssh_public_keys = var.ssh_public_key
  depends_on = [ proxmox_lxc.LAB-S02-Proxy ]

  memory = 1024
  cores = 4
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
    bridge = "vmbr0"
    ip     = "10.120.69.2/28"
    gw     = "10.120.69.1"
  }
  network {
    name   = "eth1"
    bridge = "vmbr1"
    ip     = "10.120.69.17/28"
  }
  network {
    name   = "eth2"
    bridge = "vmbr2_MGMT"
    ip     = "10.120.69.33/28"
  }
  network {
    name   = "eth3"
    bridge = "vmbr3"
    ip     = "10.120.69.49/28"
  }
  network {
    name   = "eth5"
    bridge = "vmbr5_LAN"
    ip     = "10.120.69.81/28"
  }
  network {
    name   = "eth6"
    bridge = "vmbr6_WiFi"
    ip     = "10.120.69.97/28"
  }
}

resource "proxmox_lxc" "LAB-S02-Proxy" {
  vmid        = 101
  target_node = var.node
  hostname = "LAB-S02-Proxy"
  ostemplate = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  ostype = "ubuntu"
  password = var.recovery_password
  ssh_public_keys = var.ssh_public_key

  memory = 2024
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
    size = "32G"
    storage = "TestDir"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "10.120.69.5/28"
    gw     = "10.120.69.1"
  }
}