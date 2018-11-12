#!/bin/bash

set -e

vagrant snapshot restore ucp
vagrant snapshot restore dtr
vagrant snapshot restore worker-node1
vagrant snapshot restore worker-node2
vagrant snapshot restore jenkins
vagrant snapshot restore gitlab
