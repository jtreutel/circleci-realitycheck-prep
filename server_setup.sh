#!/bin/bash
set -x

while getopts h:t:v:n:o: flag 
do 
	case "${flag}" in 
		h) host=${OPTARG};; 		#https://yourserver.example.com
		t) token=${OPTARG};; 		#abcde12345abcde12345abcde12345abcde12345abcde12345
		v) vcs_type=${OPTARG};; 	#github or bitbucket
		n) namespace=${OPTARG};; 	#yournamespace
		o) org_name=${OPTARG};; 	#myvcsorgname
	esac 
done

if TEST-COMMAND
then
  STATEMENTS
fi

#Lazy but probably okay for now
[[ ${vcs_type} == "github" ]] && vcs_short="gh" || vcs_short="bb"

echo "Host: $host"; echo "Token: $token"; echo "VCS Type: $vcs_type / $vcs_short"; echo "Namespace: $namespace"



echo; echo "Creating context org-global..."
circleci context create ${vcs_type} ${namespace} org-global --host ${host} --token ${token}

echo; echo "Creating context individual-local..."
circleci context create ${vcs_type} ${namespace} individual-local --host ${host} --token ${token}

echo; echo "Store secret CONTEXT_END_TO_END_TEST_VAR in org-global..."
echo | circleci context store-secret ${vcs_type} ${namespace} org-global CONTEXT_END_TO_END_TEST_VAR --host ${host} --token ${token}

echo; echo "Store secret MULTI_CONTEXT_END_TO_END_VAR in individual-local..."
echo | circleci context store-secret ${vcs_type} ${namespace} individual-local MULTI_CONTEXT_END_TO_END_VAR --host ${host} --token ${token}

#Wish we could do this with the CLI
echo; echo "Creating env vars for realitycheck project..."
curl --request POST --url "${host}/api/v2/project/${vcs_short}/${org_name}/realitycheck/envvar" --header "Circle-Token: ${token}" --header 'content-type: application/json' --data "{\"name\":\"CIRCLE_HOSTNAME\",\"value\":\"${host}\"}"
curl --request POST --url "${host}/api/v2/project/${vcs_short}/${org_name}/realitycheck/envvar" --header "Circle-Token: ${token}" --header 'content-type: application/json' --data "{\"name\":\"CIRCLE_TOKEN\",\"value\":\"${token}\"}"


echo; echo "List contexts and vars for verification..."
circleci context list ${vcs_type} ${namespace} --host ${host} --token ${token}
circleci context show ${vcs_type} ${namespace} org-global --host ${host} --token ${token}
circleci context show ${vcs_type} ${namespace} individual-local --host ${host} --token ${token}


echo; echo "List realitycheck project-level environment variables for verification..."
curl --request GET --url "${host}/api/v2/project/${vcs_short}/${org_name}/realitycheck/envvar" --header "Circle-Token: ${token}"