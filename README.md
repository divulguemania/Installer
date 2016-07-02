# Version #
v.2.0.3

Tested on:

- Debian 8 Jessie (VmWare Esxi, Amazon AWS, Virtualbox, OVH VPS)
- Debian 7 Wheezy (VmWare Esxi, Amazon AWS, Virtualbox, OVH VPS)
- Ubuntu 14.04 Trusty (VmWare Esxi, Amazon AWS, Virtualbox, OVH VPS)
- Ubuntu 15.10 Willy (VmWare Esxi, Amazon AWS, Virtualbox, OVH VPS)
- Centos 7 (Vitualbox)

to install debian as required for ISPConfig

* Configuration for Debian 7 / 8 - Ubuntu 14.04 / 15.10

After you got a fresh and perfect Debian installation you had to

```shell
cd /tmp; wget "https://github.com/DivulgueManiaOficial/Installer/archive/master.zip"; unzip -a  installer.zip; cd *Installer*; bash install.sh
```
* Centos 7

```shell
cd /tmp; yum install wget unzip net-tools; wget "https://github.com/DivulgueManiaOficial/Installer/archive/master.zip"; unzip -a  installer.zip; cd *Installer*; bash install.sh
```
