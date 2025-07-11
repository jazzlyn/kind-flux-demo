# --------------------------------------------------------------------------------
# CONFIGURE TERRAFORM
# --------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.3.0, <= 1.12.2"
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.9.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }
  }
}

locals {
  kubeconfig_path        = pathexpand("~/.kube/config")
  registry_name          = "kind-registry"
  registry_port          = "5050"
  registry_internal_port = "5000"
  registry_docker_image  = "registry:2.8.1"
  kind_cluster_name      = "kind-flux-demo"
}

resource "kind_cluster" "flux_demo" {
  name            = local.kind_cluster_name
  kubeconfig_path = local.kubeconfig_path
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    containerd_config_patches = [
      # configure local oci registry
      <<EOF
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${local.registry_port}"]
            endpoint = ["http://${local.registry_name}:${local.registry_internal_port}"]
        EOF
    ]

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        # ingress label
        <<EOF
          kind: InitConfiguration
          nodeRegistration:
            kubeletExtraArgs:
              node-labels: "ingress-ready=true"
          EOF
      ]

      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
      # extra_mounts {
      #   host_path      = var.app_src
      #   container_path = "/src"
      # }
    }

    # add 1 worker node
    node {
      role = "worker"
      # extra_mounts {
      #   host_path      = var.app_src
      #   container_path = "/src"
      # }
    }
  }
}

# create oci registry docker container
resource "docker_image" "registry" {
  name = local.registry_docker_image
}

# Create a container
resource "docker_container" "kind_registry" {
  depends_on = [
    kind_cluster.flux_demo
  ]
  image   = docker_image.registry.image_id
  name    = local.registry_name
  attach  = false
  restart = "unless-stopped"
  ports {
    internal = local.registry_internal_port
    external = local.registry_port
    ip       = "127.0.0.1"
  }
  networks_advanced {
    name = "kind"
  }
}
