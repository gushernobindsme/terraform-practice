resource "aws_iam_role" "default" {
  name               = var.name
  assume_role_policy = data.aws_iam_role_policy_document.assume_role.json
}

data "aws_iam_role_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = [var.identifier]
    }
  }
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}
