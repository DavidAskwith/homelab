resource "incus_image" "alpine-test" {
  source_image = {
    remote = "images"
    name   = "alpine/edge"
  }
}
