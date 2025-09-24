resource "proxmox_lxc" "LAB-S01-FW" {
  vmid        = 100
  target_node = var.node
  bwlimit = 0
  cmode = "tty"
  cores = 2
  hostname = "LAB-S01-FW"
  memory = 1024
  ostype = "ubuntu"
  restore = false
  force = false
  ignore_unpack_errors = false
  start = true
  template = false
  unique = false
  swap = 512
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
}