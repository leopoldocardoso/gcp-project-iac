resource "google_artifact_registry_repository" "gcr_repository" {
  location      = "us-central1"
  repository_id = "gcr-repository"
  description   = "docker repository"
  format        = "DOCKER"

  docker_config {
    immutable_tags = true
  }
}
