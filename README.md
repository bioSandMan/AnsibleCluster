Create/configure Cassandra/Spark cluster
==============================================
Assumptions: You know your way around a Linux box and you know GIYF.

This playbook creates a single cluster of muliple nodes on a single rack called 'rack1' and a datacenter name of 'dc1'.

First, install Ansible on a machine that has access to the cluster. We will call this machine deployer.
On the deployer machine you need to edit your inventory file which is (by default)

/etc/ansible/hosts

Add something like the following at the end of /etc/ansible/hosts:

[worker_nodes]
<CASSANDRA_NODE1> node_ip=<NODE_IP_ADDRESS> ansible_become=true ansible_become_method=sudo dc=dc1 rack=rack1
<CASSANDRA_NODE2> node_ip=<NODE_IP_ADDRESS> ansible_become=true ansible_become_method=sudo dc=dc1 rack=rack1
<CASSANDRA_NODE3> node_ip=<NODE_IP_ADDRESS> ansible_become=true ansible_become_method=sudo dc=dc1 rack=rack1
<CASSANDRA_NODE4> node_ip=<NODE_IP_ADDRESS> ansible_become=true ansible_become_method=sudo dc=dc1 rack=rack1
...

[all_nodes]
<CASSANDRA_NODE1> node_ip=<NODE_IP_ADDRESS> ansible_become=true ansible_become_method=sudo dc=dc1 rack=rack1
<CASSANDRA_NODE2> node_ip=<NODE_IP_ADDRESS> ansible_become=true ansible_become_method=sudo dc=dc1 rack=rack1
<CASSANDRA_NODE3> node_ip=<NODE_IP_ADDRESS> ansible_become=true ansible_become_method=sudo dc=dc1 rack=rack1
<CASSANDRA_NODE4> node_ip=<NODE_IP_ADDRESS> ansible_become=true ansible_become_method=sudo dc=dc1 rack=rack1
...
<CASSANDRA_HEAD_NODE> node_ip=<HEAD_NODE_IP_ADDRESS> ansible_become=true ansible_become_method=sudo dc=dc1 rack=rack1

[head_node]
<CASSANDRA_HEAD_NODE> node_ip=<HEAD_NODE_IP_ADDRESS> ansible_become=true ansible_become_method=sudo dc=dc1 rack=rack1

In the file /etc/ansible/ansible.cfg uncomment/edit the following:

inventory = /etc/ansible/hosts
sudo_user = <SUDO USER>
ask_sudo_pass = True
ask_pass = True
host_key_checking = False

If you are using ssh keys you don't need to uncomment ask_pass.

Make sure you are using the correct sudo user.

Change the global variable in the group_vars/all file to match the current cluster configuration.

To create a new empty cluster: 
ansible-playbook -i <inventory> --extra-vars="init_server=true" cassandra.yml 

To start spark slaves
First, make sure spark master is running on master node with
sudo <SPARK_HOME>/sbin/start-master.sh

You can stop the spark master with:
sudo <SPARK_HOME>/sbin/stop-master.sh


Then
ansible-playbook -i <inventory> --extra-vars="start_slaves=true" cassandra.yml 

To stop spark slaves
ansible-playbook -i <inventory> --extra-vars="stop_slaves=true" cassandra.yml 

To update configuration files
ansible-playbook -i <inventory> --extra-vars="update_config=true" cassandra.yml
