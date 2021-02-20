#!/bin/sh

set -e

display_help() {
    echo "Usage: $0 [options...]" >&2
    echo
    echo "   -p, --platforms     set target platform for build."
    echo "   -h, --help          show this help text"
    echo
    exit 1
}


for i in "$@"
do
case $i in
    -p=*|--platforms=*)
    PLATFORMS="${i#*=}"
    shift
    ;;
    -h | --help)
    display_help
    exit 0
    ;;
    *)
    display_help
    exit 0
    # unknown option
    ;;
esac
done

DOCKER_BAKE_FILE=${1:-"docker-bake.hcl"}
ALPINE_TAGS=${ALPINE_TAGS:-"3.12 3.11 3.10 latest"}
DEBIAN_TAGS=${DEBIAN_TAGS:-"stable stretch testing"}
GOCRONVER=${GOCRONVER:-"v0.0.9"}
PLATFORMS=${PLATFORMS:-"linux/amd64 linux/arm64"}
IMAGE_NAME=${IMAGE_NAME:-"akhilrs/mongodb-cloud-backup"}

cd "$(dirname "$0")"

MAIN_TAG="latest"
# T="\"$(echo $ALPINE_TAGS | sed 's/ /-alpine", "/g')\", \"$(echo $DEBIAN_TAGS | sed 's/ /-debian", "/g')\""
T="\"$(echo $ALPINE_TAGS | sed 's/ /-alpine", "/g')\""

P="\"$(echo $PLATFORMS | sed 's/ /", "/g')\""

cat > "$DOCKER_BAKE_FILE" << EOF
group "default" {
	targets = [$T]
}
target "common" {
	platforms = [$P]
	args = {"GOCRONVER" = "$GOCRONVER"}
}
# target "debian" {
# 	inherits = ["common"]
# 	dockerfile = "Dockerfile-debian"
# }
target "alpine" {
	inherits = ["common"]
	dockerfile = "Dockerfile-alpine"
}
target "latest" {
  inherits = ["alpine"]
	args = {"BASETAG" = "latest"}
  tags = ["$IMAGE_NAME:latest"]
}
EOF

# for TAG in $DEBIAN_TAGS; do cat >> "$DOCKER_BAKE_FILE" << EOF
# target "debian-$TAG" {
#   inherits = ["debian"]
# 	args = {"BASETAG" = "$TAG"}
#   tags = ["$IMAGE_NAME:$TAG-debian"]
# }
# EOF
# done

for TAG in $ALPINE_TAGS; do cat >> "$DOCKER_BAKE_FILE" << EOF
target "$TAG-alpine" {
  inherits = ["alpine"]
	args = {"BASETAG" = "$TAG"}
  tags = ["$IMAGE_NAME:$TAG-alpine"]
}
EOF
done