# Caller identity (gets AWS account ID dynamically)
data "aws_caller_identity" "current" {}

# IAM Role for EC2 instances
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    {
      Name = "EC2Role-${var.environment}"
    },
    var.tags
  )
}

# IAM Policy Attachment for SSM
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Policy Attachment for CloudWatch
resource "aws_iam_role_policy_attachment" "cw" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2InstanceProfile-${var.environment}"
  role = aws_iam_role.ec2_role.name
}

# IAM Policy to allow EC2 instances to read DB password from SSM Parameter Store
resource "aws_iam_policy" "ssm_db_access" {
  name        = "ssm-db-access-${var.environment}"
  description = "Allow EC2 to read DB password from SSM Parameter Store"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/${var.environment}/db/password"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_ssm_db_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ssm_db_access.arn
}
