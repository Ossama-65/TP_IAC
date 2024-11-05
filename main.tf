terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.25.0"
    }
  }
}

provider "docker" {}

# Réseau Docker
resource "docker_network" "my_network" {
  name = "tp_network"
}

resource "docker_image" "nginx" {
  name = "nginx"
}

resource "docker_image" "php_fpm" {
  name = "php:fpm"
}


# Conteneur HTTP (NGINX)
resource "docker_container" "http" {
  name  = "http_container"
  image = docker_image.nginx.name
  networks_advanced {
    name = docker_network.my_network.name
  }
  ports {
    internal = 80
    external = 8080
  }
}

# Conteneur SCRIPT (PHP FPM)
resource "docker_container" "script" {
  name  = "php_fpm_container"
  image = docker_image.php_fpm.name
  networks_advanced {
    name = docker_network.my_network.name
  }
}

