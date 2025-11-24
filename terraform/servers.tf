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

resource "proxmox_lxc" "LAB-S04-RootCA" {
  vmid        = 105
  target_node = var.node
  hostname = "LAB-S04-RootCA"
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
    ip     = "10.120.69.21/28"
    gw     = "10.120.69.17"
  }
}

resource "proxmox_vm_qemu" "LAB-S11-Apps" {
  name        = "LAB-S11-Apps"
  target_node = var.node

  # must create template with scripts/create-fedora-base-template.sh
  clone = "LAB-T01-Fedora"

  os_type = "cloud-init"
  full_clone = true
  agent      = 1

  cpu {
    cores   = 4
    sockets = 1
    # fastest virtualization
    type    = "host"
  }
  memory  = 8192
  # docker host needs stable memory
  balloon = 0

  scsihw  = "virtio-scsi-pci"
  disk {
    size    = "30G"
    type    = "disk"
    storage = "TestDir"
    format  = "raw"
    slot    = "scsi0"
  }

  disk {
    type    = "cloudinit"
    slot    = "ide0"
    storage = "TestDir"
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr1"
  }

  ipconfig0 = "ip=10.120.69.29/28,gw=10.120.69.17"

  sshkeys = var.ssh_public_key

  ciuser  = "fedora"
  cipassword = ""   # SSH keys only
}