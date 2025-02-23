import os, subprocess
from tempfile import mkstemp
from shutil import move, copymode
from os import fdopen, remove

def replace(file_path, pattern, subst):
    fh, abs_path = mkstemp()
    with fdopen(fh,'w') as new_file:
        with open(file_path) as old_file:
            for line in old_file:
                new_file.write(line.replace(pattern, subst))
    copymode(file_path, abs_path)
    remove(file_path)
    move(abs_path, file_path)

gpu_codes = subprocess.check_output(['lspci', '-s', '01:00', '-n']).decode()[:-1]
gpu_codes = [ o.split(' ')[-3] for o in gpu_codes.split('\n')]
gpu_codes = ','.join(gpu_codes)
GRUB_CMDLINE_LINUX_DEFAULT=f"GRUB_CMDLINE_LINUX_DEFAULT=quiet intel_iommu=on pcie_acs_override=downstream,multifunction initcall_blacklist=sysfb_init video=vesa:off vfio-pci.ids={gpu_codes} vfio_iommu_type1.allow_unsafe_interrupts=1 kvm.ignore_msrs=1 modprobe.blacklist=radeon,nouveau,nvidia,nvidiafb,nvidia-gpu"
print(GRUB_CMDLINE_LINUX_DEFAULT)
replace(f"{os.getcwd()}/grub" , "GRUB_CMDLINE_LINUX_DEFAULT", GRUB_CMDLINE_LINUX_DEFAULT)

modules = ["vfio","vfio_iommu_type1","vfio_pci","vfio_virqfd"]
with open("/etc/modules",'w') as f:
    for module in modules:
        f.write(f"{module}\n")
    