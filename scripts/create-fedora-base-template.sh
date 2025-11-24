#!/bin/bash
set -e

# run this script on your Proxmox host in order to create fedora cloud-init template

VM_ID="9000"
VM_NAME="LAB-T01-Fedora"
MEMORY="2048"
CORES="2"
STORAGE_POOL="TestDir"
IMAGE_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2"
IMAGE_FILENAME=$(basename "${IMAGE_URL}")

# cleanup previous attempts
if qm status $VM_ID >/dev/null 2>&1; then
    echo "VM ${VM_ID} already exists. Stopping and destroying..."
    qm stop $VM_ID || true
    qm destroy $VM_ID
fi

# download the image if doesn't exist
if [ ! -f "/var/lib/vz/template/iso/${IMAGE_FILENAME}" ]; then
    echo "Downloading Fedora Cloud image..."
    wget -O "/var/lib/vz/template/iso/${IMAGE_FILENAME}" "${IMAGE_URL}"
fi

# create a new VM
echo "Creating VM ${VM_ID}..."
qm create $VM_ID --name $VM_NAME --memory $MEMORY --cores $CORES --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci

# import the downloaded disk to the target storage
echo "Importing disk..."
qm importdisk $VM_ID "/var/lib/vz/template/iso/${IMAGE_FILENAME}" $STORAGE_POOL

# attach the new disk to the VM as a SCSI drive
echo "Attaching disk..."
qm set $VM_ID --scsi0 ${STORAGE_POOL}:vm-${VM_ID}-disk-0,discard=on,ssd=1

# add Cloud-Init drive
echo "Configuring Cloud-Init drive..."
# do not attach cloudinit disk - terraform will do this later
# qm set $VM_ID --ide2 ${STORAGE_POOL}:cloudinit
qm set $VM_ID --boot c --bootdisk scsi0

# convert the VM to a template
echo "Converting VM to a template..."
qm template $VM_ID

echo "Successfully created template ${VM_NAME} (ID: ${VM_ID})."