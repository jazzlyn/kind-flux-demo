# --------------------------------------------------------------------------------
# CONFIGURE PROVIDERS
# --------------------------------------------------------------------------------

provider "kind" {}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}
