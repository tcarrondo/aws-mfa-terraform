#!/bin/bash

# Requirements:
# packages: jq awscli
# Usage: 
# add an alias like:
# alias token-aws='<PATH>/aws-creds-update.sh'
# rename/copy config.vars-temp to config.vars and edit it
# then:
# $ token-aws 000000 [another duration, in seconds, if needed]

type jq >/dev/null 2>&1 || { printf >&2 "jq is required for this script, but it's not installed.  Aborting."; exit 1; }
type aws >/dev/null 2>&1 || { printf >&2 "aws is required for this script, but it's not installed.  Aborting."; exit 1; }

jq_filter='.[].Credentials.AccessKeyId,.[].Credentials.SecretAccessKey,.[].Credentials.SessionToken'

# need another duration?
special_duration=$2
duration=${special_duration:=$token_duration}

# get the token
aws sts get-session-token --profile $aws_base_profile --token-code $1 --serial-number $mfa_token_sn --duration-seconds $duration | jq --slurp -r $jq_filter > ~/.new-creds

# update aws profile
aws --profile $aws_update_profile configure set aws_access_key_id $(sed '1q;d' ~/.new-creds)
aws --profile $aws_update_profile configure set aws_secret_access_key $(sed '2q;d' ~/.new-creds)
aws --profile $aws_update_profile configure set aws_session_token $(sed '3q;d' ~/.new-creds)

rm ~/.new-creds
