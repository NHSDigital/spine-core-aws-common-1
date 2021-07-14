data "archive_file" "mesh_aws_client" {
  type        = "zip"
  source_dir  = "${path.module}/../../mesh_aws_client"
  output_path = "${path.module}/mesh_aws_client.zip"
}

resource "null_resource" "mesh_aws_client_dependencies" {
  triggers = {
    # hack so this always triggers
    mesh_aws_client_dependencies = timestamp()
  }
  provisioner "local-exec" {
    command = "/bin/bash ${path.module}/scripts/mesh_aws_client_dependencies.sh"
  }
}

data "archive_file" "mesh_aws_client_dependencies" {
  type        = "zip"
  source_dir  = "${path.module}/mesh_aws_client_dependencies"
  output_path = "${path.module}/mesh_aws_client_dependencies.zip"

  depends_on = [
    null_resource.mesh_aws_client_dependencies
  ]
}

resource "aws_lambda_layer_version" "mesh_aws_client_dependencies" {
  filename            = data.archive_file.mesh_aws_client_dependencies.output_path
  layer_name          = "mesh_aws_client_dependencies"
  source_code_hash    = data.archive_file.mesh_aws_client_dependencies.output_base64sha256
  compatible_runtimes = [local.python_runtime]

  depends_on = [
    null_resource.mesh_aws_client_dependencies
  ]
}
