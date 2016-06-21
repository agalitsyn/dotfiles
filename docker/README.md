CGroups memory limit not working:
* add cgroup_enable=memory swapaccount=1 to whatever is currently in the GRUB_CMDLINE_LINUX_DEFAULT var in /etc/default/grub
* sudo update-grub to make it ready to use
* restart the instance, should be workinig
