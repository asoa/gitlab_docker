packer {
    required_plugins {
        azure = {
            version = ">= 1.0.0"
            source  = "github.com/hashicorp/azure"
        }
        windows-update = {
            version = ">= 0.14.0"
            source  = "github.com/rgl/windows-update"
        }
    }
}