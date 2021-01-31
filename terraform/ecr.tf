resource "aws_ecr_repository" "this" {
  name = "${local.app_name}-repository"
}

resource "null_resource" "docker" {
  triggers = {
    app_name = filemd5("${var.app_folder}/server.js")
  }

  provisioner "local-exec" {
    working_dir = var.app_folder
    command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin 132818155912.dkr.ecr.us-east-1.amazonaws.com"
  }

  provisioner "local-exec" {
    working_dir = var.app_folder
    command = "docker build -t ${local.app_name} ."
  }
  provisioner "local-exec" {
    working_dir = var.app_folder
    command = "docker tag ${local.app_name}:latest ${aws_ecr_repository.this.repository_url}:latest"
  }
  provisioner "local-exec" {
    working_dir = var.app_folder
    command = "docker push ${aws_ecr_repository.this.repository_url}:latest"
  }
}