data "google_iam_policy" "admin" {
  binding {
    role = "roles/artifactregistry.reader"
    members = [
      "user:lp.estudos.gcp@gmail.com",
    ]
  }
}

resource "google_artifact_registry_repository_iam_policy" "policy" {
  project     = google_artifact_registry_repository.gcr_repository.project
  location    = google_artifact_registry_repository.gcr_repository.location
  repository  = google_artifact_registry_repository.gcr_repository.name
  policy_data = data.google_iam_policy.admin.policy_data
  depends_on  = [google_artifact_registry_repository.gcr_repository]
}
