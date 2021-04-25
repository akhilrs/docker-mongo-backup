![Docker Pulls](https://hub.docker.com/repository/docker/akhilrs/mongodb-cloud-backup)

# mongodb-cloud-backup

Backup MongoDB to the cloud with periodic rotating backups.

Supports the following Docker architectures: `linux/amd64`.

## Usage


Docker Swarm:
```yaml
version: '2'
services:
    mongo_backup:
    image: akhilrs/mongodb-cloud-backup:latest
    deploy:
      replicas: 1
      restart_policy:
        condition: on-failure
      resources:
        limits:
          memory: 1G
    environment:
      - SCHEDULE=@every 0h5m0s # https://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules
      - BACKUP_KEEP_DAYS=1
      - BACKUP_KEEP_WEEKS=1
      - BACKUP_KEEP_MONTHS=1
      - HEALTHCHECK_PORT=80
      - CLOUD_BACKUP=True
      - CLOUD_PROVIDER=Azure
      - AZURE_SA_CONNECTION_STRING=${AZ_SA_CONNECTION}
      - AZURE_SA_CONTAINER=mongo-backups
      - MONGO_DATABASE=mg_database
      - MONGO_HOST=mongo_db
      - MONGO_USERNAME=${MONGO_USERNAME}
      - MONGO_PASSWORD=${MONGO_PASSWORD}
      - MONGO_AUTH_DB=admin

    volumes:
      - /data_drive/app/data/mongo-backups:/backups
    networks:
      - backend_nw

```

### Environment Variables

| env variable | description |
|--|--|
| BACKUP_DIR | Directory to save the backup at. Defaults to `/backups`. |
| BACKUP_KEEP_DAYS | Number of daily backups to keep before removal. Defaults to `7`. |
| BACKUP_KEEP_WEEKS | Number of weekkly backups to keep before removal. Defaults to `4`. |
| BACKUP_KEEP_MONTHS | Number of monthly backups to keep before removal. Defaults to `6`. |
| HEALTHCHECK_PORT | Port listening for cron-schedule health check. Defaults to `8080`. |
| CLOUD_BACKUP |  If True, backup will push to supporting cloud system. Requried. |
| CLOUD_PROVIDER | For setting cloud provider configuration, currently supporting providers are Azure and AWS. |
| AZURE_SA_CONNECTION_STRING | Azure storage account connection string. |
| AZURE_SA_CONTAINER | Azure storage account container name. |
| MONGO_DATABASE | Mongo connection parameter; mongo dabase name to connect with. Required. |
| MONGO_HOST | Mongo connection parameter; mongo host name. Required |
| MONGO_USERNAME | Mongo connection parameter; mongo user to connect with. Required. |
| MONGO_PASSWORD | Mongo connection parameter; mongo password. Required. |
| MONGO_AUTH_DB |
| SCHEDULE | [Cron-schedule](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules) specifying the interval between postgres backups. Defaults to `@daily`. |


### Manual Backups

By default this container makes daily backups, but you can start a manual backup by running `/backup.sh`:

```sh
$ docker run -e {envs}  akhilrs/mongodb-cloud-backup /backup.sh
```

### Automatic Periodic Backups

You can change the `SCHEDULE` environment variable in `-e SCHEDULE="@daily"` to alter the default frequency. Default is `daily`.

More information about the scheduling can be found [here](http://godoc.org/github.com/robfig/cron#hdr-Predefined_schedules).

Folders `daily`, `weekly` and `monthly` are created and populated using hard links to save disk space.
