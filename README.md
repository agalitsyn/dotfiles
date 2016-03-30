## dotfiles-ansible

Continuation of my [dotfiles](https://github.com/agalitsyn/dotfiles) through
[Ansible](http://www.ansible.com/), a tool to configure and manage computers.

Now it's fully supports OSX, for Debian needs some work.

### Installation
Use the boostrap.sh shell script to install Ansible. Either command will work.

Test run the provisioning.
```bash
$ make dryrun
$ source ~/.bashrc
```

Run the provisioning.
```bash
$ make install
$ source ~/.bashrc
```
