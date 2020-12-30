resource "aws_sqs_queue" "broker" {
  name = "broker"
}

data "aws_iam_policy_document" "broker_access" {
  statement {
    actions = [
      "sqs:*"
    ]

    resources = [
      "arn:aws:sqs:*:*:worker_*"
    ]
  }
}

resource "aws_iam_policy" "broker" {
  name   = "broker"
  policy = data.aws_iam_policy_document.broker_access.json
}

resource "aws_iam_role_policy_attachment" "server_broker" {
  # TODO: This assumes the internal role name in the girder module.  Perhaps
  #       we should add the role as an output, or provide some way to customize
  #       policies attached to the girder instance.
  role       = var.project_slug
  policy_arn = aws_iam_policy.broker.arn
}

resource "aws_iam_role_policy_attachment" "worker_broker" {
  role       = aws_iam_role.worker.name
  policy_arn = aws_iam_policy.broker.arn
}
