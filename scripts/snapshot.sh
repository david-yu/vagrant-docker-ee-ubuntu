#!/bin/bash

vagrant snapshot push ucp
vagrant snapshot push dtr
vagrant snapshot push worker-node1
vagrant snapshot push worker-node2
vagrant snapshot push jenkins
vagrant snapshot push gitlab
