

password=$MASTER_KEY
image="/mnt/pve/storage02/dump/vzdump-qemu-200-2024_11_28-17_56_55.vma.zst" 
source restore_vm.sh $password caloba-v11 $image storage02 caloba95 295 95 base $LPS_CLUSTER_HOSTS

