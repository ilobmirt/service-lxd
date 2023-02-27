## **SERVICE-LXD**
* * *
service-lxd is a role designed to be run within an [ansible](https://www.ansible.com/) playbook. This role is responsible for initializing, cleaning up, or removing LXD as a service for each node within the group listed in the service-lxd role.

## Configuring the service-lxd role
* * *
This role is configured through the ***lxd_service_config*** variable in the ***playbook.yml*** file. 
***lxd_service_config*** is a dictionary object that will overlap changes with the actual variable used for the role - ***applied_lxd_role_config*** . ***applied_lxd_role_config*** is the full configuration for the role containing every detail about the project. It's not recommended you edit that variable.

## Example Project
* * *
In this example, we already had deployed an lxd cluster early on ( probably the default un-clustered configuration ) , but we have a new configuration to apply (Such as running these hosts as a cluser ) . Therefore, we will use the **service-lxd** role to clean up the server and then reimplement the service under the new configuration.

**hosts.ini**
```ini
[lxd_hosts]
vnode3 ansible_host=█.█.█.3
vnode4 ansible_host=█.█.█.4
vnode5 ansible_host=█.█.█.5
vnode6 ansible_host=█.█.█.6
vnode7 ansible_host=█.█.█.7

[lxd_hosts:vars]
ansible_user=lxduser
ansible_python_interpreter=auto
```

**vars/provision_lxd.yml**
```yaml
lxd_service_config:
  target_user: 'lxduser'
  is_cluster: True
  tasks:
    - CLEAN
    - UP_STORAGE
    - UP_SERVICE
```

**playbook.yml**
```yaml
- hosts: lxd_hosts
  gather_facts: yes
  
  vars_files:
    - vars/provision_lxd.yml

  roles:
    - service-lxd
```

## Development Environment
***
This Ansible role was deployed to:
- **VM HOST:** 
```
       _,met$$$$$gg.          ******@vmsrv 
    ,g$$$$$$$$$$$$$$$P.       -------------- 
  ,g$$P"     """Y$$.".        OS: Debian GNU/Linux 11 (bullseye) x86_64 
 ,$$P'              `$$$.     Host: Surface Pro 4
',$$P       ,ggs.     `$$b:   Kernel: 5.10.0-20-amd64 
`d$$'     ,$P"'   .    $$$    Uptime: 31 days, 19 hours, 25 mins 
 $$P      d$'     ,    $$P    Packages: 2322 (dpkg) 
 $$:      $$.   -    ,d$$'    Shell: bash 5.1.4 
 $$;      Y$b._   _,d$P'      Resolution: 2736x1824 
 Y$$.    `.`"Y$$$$P"'         Terminal: /dev/pts/0 
 `$$b      "-.__              CPU: Intel i5-6300U (4) @ 3.000GHz 
  `Y$$                        GPU: Intel Skylake GT2 [HD Graphics 520] 
   `Y$$.                      Memory: 3089MiB / 7882MiB 
     `$$b.
       `Y$$b.                                         
          `"Y$b._                                     
              `"""
```
- **Vagrant**
```yaml
- GUEST_OS_IMAGES:
  - "debian/bullseye64"
  - "generic/fedora33"

- PROVIDER:
  - "vagrant-libvirt (0.11.2, global)"

- VERSION:
 - "2.3.4"
```

## Known Limitations:
***
The following are the current limitations of the role as of the time of this writing (2023-FEB-27). Of course though, this code is open source. Feel free to play with this at your heart's content.

- Storage pools really only have been vetted to work with DIR storage. And of that , only that within the directory given for the role. **DEFAULT:** '/lxd-system'

- OS support is limited to the Guest Os' tested in the development environment. Although it could also theoretically support Arch and Alpine distros as well

- This role currently implements LXD through **snapd**. Options to implement the service through source or by native package manager are still on the to-do list.
