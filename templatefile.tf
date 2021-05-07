data "template_file" "init" {
  template = "${file("userdata.sh")}"
  vars = {
    project_name = var.project_name,
    stage = var.Stage

  }
}
