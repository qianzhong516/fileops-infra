# TODO: Remote state sharing exposes sensitive info to the consumer (if any). Publish non-sensitive configurations to a 3rd party storage like S3 for security.
data "terraform_remote_state" "state" {
  backend = "remote"

  config = {
    organization = "janice-zhong"
    workspaces = {
      name = "janice-zhong-fileops-cluster"
    }
  }
}
