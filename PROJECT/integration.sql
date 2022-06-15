create or replace storage integration s3_int
type = external_stage
storage_provider = s3
enabled = true
storage_aws_role_arn = 'arn:aws:iam::627741535532:role/vishwanath_booleandata_role'
storage_allowed_locations = ('s3://vishwanathbooleandata/');



DESC INTEGRATION s3_int;