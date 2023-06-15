#! /bin/bash

oc delete buildconfig openshift-test
oc delete service openshift-test
oc delete deployment openshift-test
# oc delete pod openshift-test

