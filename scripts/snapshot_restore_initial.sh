#!/bin/bash

vagrant snapshot restore ucp-node1 ucp-node1-initial
vagrant snapshot restore dtr-node1 dtr-node1-initial
vagrant snapshot restore worker-node1 worker-node1-initial
vagrant snapshot restore worker-node1 worker-node2-initial
