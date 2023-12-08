locals {
  codename  = var.project_codename
  namespace = local.codename == "" ? "" : "${local.codename}-"
}
