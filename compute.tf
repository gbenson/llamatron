data "aws_ami" "ubuntu_cuda" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["*CUDA*Ubuntu*"]
  }
}

resource "aws_iam_role" "ec2_llama_host" {
  name = "EC2LlamaHost"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_llama_host" {
  name = "llama-host"
  role = aws_iam_role.ec2_llama_host.name
}

resource "aws_iam_role_policy_attachment" "ec2_llama_host_get_model_file" {
  role       = aws_iam_role.ec2_llama_host.name
  policy_arn = aws_iam_policy.model_file_get.arn
}

resource "aws_launch_template" "llama" {
  name     = "x64_64-llama-host"
  image_id = data.aws_ami.ubuntu_cuda.id

  update_default_version = true

  instance_requirements {
    vcpu_count {
      min = 1
    }
    memory_mib {
      min = "4096"
    }
    accelerator_count {
      min = 1
    }
    accelerator_manufacturers = ["nvidia"]
    accelerator_types         = ["gpu"]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_llama_host.name
  }

  vpc_security_group_ids = [aws_security_group.ssh_admin.id]
  key_name               = aws_key_pair.admin_ssh_key.id
}
