
resource "google_project_iam_member" "gke_admin" {
  for_each = toset(var.gke_admins)

  project = var.project_id
  role    = "roles/container.admin"
  member  = "user:${each.value}"
}



