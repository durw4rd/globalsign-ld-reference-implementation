terraform {
  required_providers {
    launchdarkly = {
      source  = "launchdarkly/launchdarkly"
      version = "~> 2.0"

    }
  }


  # required_version = "~> 1.1.6"
}

# Configure the LaunchDarkly provider
provider "launchdarkly" {
  access_token = var.launchdarkly_access_token
}

variable "launchdarkly_access_token" {
  type = string 
  sensitive = true
  description = "LaunchDarkly access token"
}


# /* Example: Create per-project roles using the project-roles module */
# module "default-project-roles" {
#   source = "./roles/flag-lifecycle"
#   project = {
#     key  = "default"
#     name = "Default project"
#   }
#   environments = {
#     "test" = {
#       key = "test"
#       name = "Test"
#     },
#     "production" = {
#       key = "production"
#       name = "Production"
#     }
#   }
# }

# /* Example: Create roles for projects matching a prefix */
# module "sandbox-prefix-project-roles" {
#   source = "./roles/flag-lifecycle"
#   project = {
#     key  = "sandbox-*"
#     name = "Sandbox projects"
#   }
#   // `role_key` is appended to generated role keys
#   // we need to set it since `sandbox-*` is not a valid role key
#   // example roles: flag-manager-sandbox, archiver-sandbox, etc
#   role_key = "sandbox"
#   environments = {
#     "test" = {
#       key = "test"
#       name = "Test"
#     },
#     "production" = {
#       key = "production"
#       name = "Production"
#     }
#   }
# }

/* Example: Create roles for preproduction/production using wildcards and denies */
module "preproduction-production-roles" {
  source = "./roles/flag-lifecycle"
  project = {
    key  = "atlas"
    name = "Atlas"
  }

  environments = {
    // the map key is used to generate role keys
    // for example: flag-maintainer-default-preproduction
    "preproduction" = {
      // the key defines the specifier
      key = "*"
      name = "Preproduction"
    },
    "staging" = {
      key = "staging"
      name = "Staging"
    },
    "production" = {
      key = "production"
      name = "Production"
    }
  }
  // map of environments keys (as defined above) to environment kets 
  environment_excludes = {
    "preproduction" = [ "staging", "production" ]
  }
}

