# coding: utf-8

"""
FILE: aws_async.py
DESCRIPTION:
    This sample demonstrates common container operations including list blobs, create a container,
    set metadata etc.
USAGE:
    python aws_async.py <filename>
    Set the environment variables with your own values before running the sample:
    1) AWS_ACCESS_KEY - AWS Access key
    2) AWS_SECRET_KEY - AWS Secret key for accessing aws services
    3) AWS_S3_BUCKET - AWS S3 bucket name for storing the objects
"""

import asyncio
aioboto3
import os
import sys

class AWSS3Async(object):
    ACCESS_KEY = os.getenv("AWS_ACCESS_KEY", None)
    SECRET_KEY = os.getenv('AWS_SECRET_KEY', None)
    S3_BUCKET = os.getenv('AWS_S3_BUCKET', None)
    SOURCE_FILE = None

    def __init__(self, file):
        self.SOURCE_FILE = file

    async def upload_file_to_s3(self):
        # Instantiate a BlobServiceClient using a connection string
        # from azure.storage.blob.aio import BlobServiceClient
        # blob_service_client = BlobServiceClient.from_connection_string(self.CONNECTION_STRING)

        # async with blob_service_client:
        #     # Instantiate a ContainerClient
        #     container_client = blob_service_client.get_container_client(self.CONTAINER_NAME)

        #     try:
        #         await container_client.create_container()
        #     except ResourceExistsError:
        #         print("Container already exists.")

        #     path, filename = os.path.split(self.SOURCE_FILE)
        #     # [START upload_blob_to_container]
        #     try:
        #         with open(self.SOURCE_FILE, "rb") as data:
        #             blob_client = await container_client.upload_blob(name=filename, data=data, blob_type=self.BLOB_TYPE)
        #     except ResourceExistsError:
        #         print("Blob with name {} already exists.".format(filename))
        
        blob_s3_key = f"{suite}/{release}/{filename}"

        async with aioboto3.client("s3") as s3:
            try:
                with staging_path.open("rb") as spfp:
                    LOG.info(f"Uploading {blob_s3_key} to s3")
                    await s3.upload_fileobj(spfp, bucket, blob_s3_key)
                    LOG.info(f"Finished Uploading {blob_s3_key} to s3")
            except Exception as e:
                LOG.error(f"Unable to s3 upload {staging_path} to {blob_s3_key}: {e} ({type(e)})")
                return ""





async def main():
    file_path = sys.argv[1]
    aws_client = AWSS3Async(file=file_path)
    await aws_client.upload_file_to_s3()


if __name__ == '__main__':
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())