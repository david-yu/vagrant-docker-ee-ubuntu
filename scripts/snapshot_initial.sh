#!/bin/bash

vagrant snapshot save ucp-node1 ucp-node1-initial
vagrant snapshot save dtr-node1 dtr-node1-initial
vagrant snapshot save worker-node1 worker-node1-initial
vagrant snapshot save worker-node1 worker-node2-initial
