#!/bin/bash
#set -x

while getopts h:t:v:n: flag 
do 
	case "${flag}" in 
		h) host=${OPTARG};; 
		t) token=${OPTARG};; 
		v) vcs_type=${OPTARG};; 
		n) namespace=${OPTARG};; 
	esac 
done
echo "Host: $host"; echo "Token: $token"; echo "VCS Type: $vcs_type"; echo "Namespace: $namespace"

echo; echo "Creating context org-global..."
circleci context create ${vcs_type} ${namespace} org-global --host ${host} --token ${token}

echo; echo "Creating context individual-local..."
circleci context create ${vcs_type} ${namespace} individual-local --host ${host} --token ${token}

echo; echo "Store secret CONTEXT_END_TO_END_TEST_VAR in org-global..."
echo | circleci context store-secret ${vcs_type} ${namespace} org-global CONTEXT_END_TO_END_TEST_VAR --host ${host} --token ${token}

echo; echo "Store secret MULTI_CONTEXT_END_TO_END_VAR in individual-local..."
echo | circleci context store-secret ${vcs_type} ${namespace} individual-local MULTI_CONTEXT_END_TO_END_VAR --host ${host} --token ${token}

#verify
echo; echo "List contexts and vars for verification..."
circleci context list ${vcs_type} ${namespace} --host ${host} --token ${token}
circleci context show ${vcs_type} ${namespace} org-global --host ${host} --token ${token}
circleci context show ${vcs_type} ${namespace} individual-local --host ${host} --token ${token}