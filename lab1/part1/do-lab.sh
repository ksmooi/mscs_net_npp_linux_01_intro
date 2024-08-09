#!/usr/bin/bash

# Step 1: Create the necessary directories for bind mounts
bash provided/make_dirs.sh

# Step 2: Deploy the lab using the Containerlab configuration
sudo containerlab deploy --topo 4node-part1.clab.yml --reconfigure

# Step 3: Install bridge-utils inside the switch container with root privileges
docker exec -u root clab-lab1-part1-switch bash -c "
    apt-get update && apt-get install -y bridge-utils
"

# Step 4: Create a bridge on the switch
docker exec -u root clab-lab1-part1-switch bash -c "
    brctl addbr br0
    brctl addif br0 eth1
    brctl addif br0 eth2
    brctl addif br0 eth3
    brctl addif br0 eth4
    ip link set br0 up
"

# Step 5: Perform any additional lab setup or testing
docker exec clab-lab1-part1-host1 /lab-folder/onepkt.py host1 host2 test-pkt1
