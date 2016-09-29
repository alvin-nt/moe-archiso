MoE-archiso (https://github.com/alvin-nt/moe-archiso)

Arch Linux live image for exams. Cloned from archiso-git 
(https://aur.archlinux.org/archiso-git.git).

Changes from original archiso:
1. Removed x64.
2. Removed PXE and other unneeded boot options.
3. Included MATE, Geany, Firefox, GCC, and JDK for compiling 
applications.

Bugs:

1. VirtualBox Guest Additions kernel modules cannot be loaded during 
startups. Currently, this option is disabled.
2. The 'sandboxing' is still currently done via virtual machine 
configuration. The whole VM + live image package is still loose.
