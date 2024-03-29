def is_bucket_empty(bucket_name, s3):
    """
    This function checks if the bucket is empty and return a boolean

    Args:
        `bucket_name`: string of the bucket name
        `s3`: connection to aws s3 via boto3
    ---------------------------

    Returns:
        `boolean`: True if bucket is empty, false otherwise
    """
    response = s3.list_objects_v2(Bucket=bucket_name)
    if response['KeyCount'] == 0:
        return True
    return False
