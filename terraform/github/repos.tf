locals {
  repos = yamldecode(file("${path.module}/repos.yaml"))

  # Flatten environments across all repos
  environments = merge([
    for repo_name, repo in local.repos : {
      for env_name, env_config in try(repo.environments, {}) :
      "${repo_name}/${env_name}" => {
        repo    = repo_name
        env     = env_name
        config  = env_config
      }
    }
  ]...)
}

# Repositories
resource "github_repository" "this" {
  for_each = local.repos

  name        = each.key
  description = each.value.description
  visibility  = try(each.value.visibility, "private")

  has_issues   = true
  has_wiki     = false
  has_projects = false

  homepage_url = try(each.value.homepage_url, null)

  dynamic "pages" {
    for_each = try(each.value.github_pages, null) != null ? [each.value.github_pages] : []
    content {
      build_type = try(pages.value.build_type, "workflow")
      cname      = try(pages.value.custom_domain, null)

      dynamic "source" {
        for_each = try(pages.value.build_type, "workflow") == "legacy" ? [1] : []
        content {
          branch = try(pages.value.branch, "gh-pages")
          path   = try(pages.value.path, "/")
        }
      }
    }
  }

  lifecycle {
    # Repos are created manually or already exist — don't destroy on removal from registry
    prevent_destroy = true
  }
}

# Environments
resource "github_repository_environment" "this" {
  for_each = local.environments

  repository  = each.value.repo
  environment = each.value.env

  dynamic "reviewers" {
    for_each = try(each.value.config.reviewers, false) ? [1] : []
    content {
      users = var.github_token != "" ? [data.github_user.current[0].id] : []
    }
  }

  depends_on = [github_repository.this]
}

# Look up the authenticated user for environment reviewer
data "github_user" "current" {
  count    = length([for _, e in local.environments : e if try(e.config.reviewers, false)]) > 0 ? 1 : 0
  username = ""
}
