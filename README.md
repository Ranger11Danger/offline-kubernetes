# Automated Offline build of HA k3s Cluster with `kube-vip` and `MetalLB`


This playbook will build an HA Kubernetes cluster with `k3s`, `kube-vip` and MetalLB via `ansible`.

## 📖 k3s Ansible Playbook

Build a Kubernetes cluster using Ansible with k3s. The goal is easily install a HA Kubernetes cluster on machines running:

- [x] Ubuntu (tested on version 22.04)

on processor architecture:

- [X] x64


## ✅ System requirements

- Control Node (the machine you are running `ansible` commands) must have Ansible 2.11+
    - `pip3 install ansible`
- You will also need to install collections that this playbook uses by running (important❗)
    - `ansible-galaxy collection install offline-collections/* -p collections/`
- [`netaddr` package](https://pypi.org/project/netaddr/) must be available to Ansible. 
    - `pip3 install netaddr`
- `server` and `agent` nodes should have passwordless SSH access, if not you can supply arguments to provide credentials `--ask-pass --ask-become-pass` to each command
    - `ssh-copy-id <username>@<each host>`

## 🚀 Getting Started

### 🍴 Preparation

Edit `inventory/my-cluster/hosts.ini` to match the system information gathered above

For example:

```ini
[master]
192.168.1.10
192.168.1.11
192.168.1.12

[node]
192.168.1.13
192.168.1.14

[k3s_cluster:children]
master
node
```

If multiple hosts are in the master group, the playbook will automatically set up k3s in [HA mode with etcd](https://rancher.com/docs/k3s/latest/en/installation/ha-embedded/).

## ⚙️ Change the following lines
Edit `inventory/my-cluster/group_vars/all.yml` to match your environment.
### <ins>Line 4

change `<user>` with the username you are using on all your nodes:
```ini
ansible_user: <user>
```
### <ins>Line 11
Change `<eth device>` to be the name of the network interface on all your nodes ie `ens160`
```ini
flannel_iface: "<eth device>"
```
### <ins>Line 14
Change `<virtual ip>` to be the load balanced ip your cluster will use, this can be whatever ip is available in your subnet and will be the ip you connect to the kubernetes api
```ini
apiserver_endpoint: <virtual ip>
```
### <ins>Line 62
change `<ip range>` to whatever range you have available for your load balancer to use in the subnet where the cluster is going to be used, for example if my cluster is getting deployed to 192.168.0.0/24 i could put `192.168.0.10-192.168.0.20` to use for my loadbalancer
```ini
metal_lb_ip_range: "<ip range>"
```
### ☸️ Create Cluster

Start provisioning of the cluster using the following command:

```bash
python3 -m ansible playbook site.yml -i inventory/my-cluster/hosts.ini
```

After deployment control plane will be accessible via virtual ip-address which is defined in inventory/group_vars/all.yml as `apiserver_endpoint`

### 🔥 Remove k3s cluster

```bash
python3 -m ansible playbook reset.yml -i inventory/my-cluster/hosts.ini
```

>You should also reboot these nodes due to the VIP not being destroyed

## ⚙️ Kube Config

To copy your `kube config` locally so that you can access your **Kubernetes** cluster run:

```bash
scp user@master_ip:~/.kube/config ~/.kube/config
```

