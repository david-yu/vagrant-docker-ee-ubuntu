#!/bin/bash

vagrant snapshot restore --no-provision ucp-node1 ucp-node1-initial
vagrant snapshot restore --no-provision dtr-node1 dtr-node1-initial
vagrant snapshot restore --no-provision worker-node1 worker-node1-initial
vagrant snapshot restore --no-provision worker-node1 worker-node2-initial
