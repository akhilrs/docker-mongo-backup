group "default" {
	targets = ["debian-latest", "alpine-latest", "debian-11", "debian-10", "debian-9.6", "debian-9.5", "debian-9.4", "alpine-11", "alpine-10", "alpine-9.6", "alpine-9.5", "alpine-9.4"]
}

target "common" {
	platforms = ["linux/amd64"]
	args = {"GOCRONVER" = "v0.0.9"}
}

target "debian" {
	inherits = ["common"]
	dockerfile = "Dockerfile-debian"
}

target "alpine" {
	inherits = ["common"]
	dockerfile = "Dockerfile-alpine"
}

target "debian-latest" {
	inherits = ["debian"]
	args = {"BASETAG" = "12"}
	tags = ["akhilrs/postgres-backup-azure-blob:latest", "akhilrs/postgres-backup-azure-blob:12"]
}

target "alpine-latest" {
	inherits = ["alpine"]
	args = {"BASETAG" = "12-alpine"}
	tags = ["akhilrs/postgres-backup-azure-blob:alpine", "akhilrs/postgres-backup-azure-blob:12-alpine"]
}

target "debian-11" {
  inherits = ["debian"]
	args = {"BASETAG" = "11"}
  tags = ["akhilrs/postgres-backup-azure-blob:11"]
}

target "alpine-11" {
  inherits = ["alpine"]
	args = {"BASETAG" = "11-alpine"}
  tags = ["akhilrs/postgres-backup-azure-blob:11-alpine"]
}

target "debian-10" {
  inherits = ["debian"]
	args = {"BASETAG" = "10"}
  tags = ["akhilrs/postgres-backup-azure-blob:10"]
}

target "alpine-10" {
  inherits = ["alpine"]
	args = {"BASETAG" = "10-alpine"}
  tags = ["akhilrs/postgres-backup-azure-blob:10-alpine"]
}

target "debian-9.6" {
  inherits = ["debian"]
	args = {"BASETAG" = "9.6"}
  tags = ["akhilrs/postgres-backup-azure-blob:9.6"]
}

target "alpine-9.6" {
  inherits = ["alpine"]
	args = {"BASETAG" = "9.6-alpine"}
  tags = ["akhilrs/postgres-backup-azure-blob:9.6-alpine"]
}

target "debian-9.5" {
  inherits = ["debian"]
	args = {"BASETAG" = "9.5"}
  tags = ["akhilrs/postgres-backup-azure-blob:9.5"]
}

target "alpine-9.5" {
  inherits = ["alpine"]
	args = {"BASETAG" = "9.5-alpine"}
  tags = ["akhilrs/postgres-backup-azure-blob:9.5-alpine"]
}

target "debian-9.4" {
  inherits = ["debian"]
	args = {"BASETAG" = "9.4"}
  tags = ["akhilrs/postgres-backup-azure-blob:9.4"]
}

target "alpine-9.4" {
  inherits = ["alpine"]
	args = {"BASETAG" = "9.4-alpine"}
  tags = ["akhilrs/postgres-backup-azure-blob:9.4-alpine"]
}
