terraform {
  backend "gcs" {
    bucket  = "tf-state-sit"
    prefix  = "sit"
  }
}