# aws-mfa-terraform
A simple script to update the **~.aws/credentials** with temporary MFA credentials.

# Usage:

## Add/edit 2 profiles to your `~/.aws/credentials`:
```
[profile-for-mfa]
aws_access_key_id = <AWS_ACCESS_KEY_ID>
aws_secret_access_key = <AWS_SECRET_ACCESS_KEY>

[profile-with-updated-token]
aws_access_key_id = REDACTED
aws_secret_access_key = REDACTED
aws_session_token = REDACTED

# Profile(s) to be used

[profile-in-use]
source_profile = profile-with-updated-token
role_arn = arn:aws:iam::123456789012:role/a_nice_role
```
(REDACTED values will be updated later when you run aws-mfa-terraform)

## Add this to a new file `~/.aws/config.vars` file:
```
# aws-mfa-terraform
mfa_token_sn=arn:aws:iam::123456789012:mfa/<AWS_PROFILE_USERNAME>
aws_base_profile=profile-for-mfa
aws_update_profile=profile-with-updated-token
token_duration=129600 # 36h, max
```

## Run the script:
```
$ ./aws-creds-update.sh
```
