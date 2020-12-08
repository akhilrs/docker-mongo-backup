import os
import sys

from azure.storage.blob import BlockBlobService

AZURE_SA = os.environ.get('AZURE_SA', None)
AZURE_SA_KEY = os.environ.get('AZURE_SA_KEY', None)
AZURE_SA_CONTAINER = os.environ.get('AZURE_SA_CONTAINER', 'sql-backups')

if (AZURE_SA and AZURE_SA_KEY) is not None:
    block_blob_service = BlockBlobService(account_name=AZURE_SA, account_key=AZURE_SA_KEY)

    dump_file_path = sys.argv[1]

    local_path, local_file_name = os.path.split(dump_file_path)

    print("Temp file = " + dump_file_path)
    print("\nUploading to Blob storage as blob " + local_file_name)

    block_blob_service.create_blob_from_path(AZURE_SA_CONTAINER, local_file_name, dump_file_path)
else:
    print("`AZURE_SA` and `AZURE_SA_KEY` are missing.")