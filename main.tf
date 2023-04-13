# Define Kubernetes cluster
resource "google_container_cluster" "cluster" {
  name     = "my-cluster"
  location = "us-central1-a"

  # Define node pool
  node_pool {
    name = "my-node-pool"

    # Specify node image
    node_config {
      image_type       = "COS_CONTAINERD"
      image_family     = "cos-89-lts"
      image_project_id = "cos-cloud"
    }
  }
}

# # Define Kubernetes Deployment for website
# resource "kubernetes_deployment" "website" {
#   metadata {
#     name = "website"
#   }

#   spec {
#     replicas = 3 # Number of container replicas

#     selector {
#       match_labels = {
#         app = "website"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "website"
#         }
#       }

#       spec {
#         container {
#           name  = "website"
#           image = "gcr.io/my-project-id/website:latest" # Container image address in GCR

#           # Mount Volume
#           volume_mount {
#             name      = "website-volume"
#             mount_path = "/path/to/website" # Mount path to 'website' folder inside the container
#           }
#         }

#         # Define Volume
#         volume {
#           name = "website-volume"
#           host_path {
#             path = "/path/to/website" # Host path to 'website' folder in the GitHub repository
#           }
#         }
#       }
#     }
#   }
# }

# # Define Google Cloud Load Balancer
# resource "google_compute_global_forwarding_rule" "website-forwarding-rule" {
#   name       = "website-forwarding-rule"
#   target     = google_compute_target_http_proxy.website-proxy.self_link
#   ip_address = google_compute_global_address.website-ip.address
#   port_range = "80"
# }

# resource "google_compute_target_http_proxy" "website-proxy" {
#   name = "website-proxy"
#   url_map = google_compute_url_map.website-url-map.self_link
# }

# resource "google_compute_url_map" "website-url-map" {
#   name = "website-url-map"

#   default_service = google_compute_backend_service.website-backend-service.self_link
# }

# resource "google_compute_backend_service" "website-backend-service" {
#   name = "website-backend-service"

#   backend {
#     default = true

#     # Specify Kubernetes Service endpoint
#     group = kubernetes_service.website-service.self_link
#   }

#   health_checks = [google_compute_health_check.website-health-check.self_link]
# }

# resource "google_compute_health_check" "website-health-check" {
#   name               = "website-health-check"
#   check_interval_sec = 10
#   timeout_sec        = 5
#   tcp_health_check {
#     port = "80"
#   }
# }

# # Define Kubernetes Service for website
# resource "kubernetes_service" "website-service" {
#   name = "website-service"

#   selector = {
#     app = kubernetes_deployment.website.spec[0].template.spec[0].metadata[0].labels.app
#   }

#   port {
#     protocol = "TCP"
#     port     = 80
#     target_port = 8080 # Port exposed by the container in the pod
#   }
# }