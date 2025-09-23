resource "proxmox_lxc" "PL2000-LFW-001" {
  name        = "PL2000-LFW-001"
  vmid        = 100
  target_node = var.node
}