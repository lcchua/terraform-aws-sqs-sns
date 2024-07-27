# Create SQS queue
resource "aws_sqs_queue" "tf_queue" {
  name                      = "ce7-lcchua-tf-sqs1"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

}

# Create SNS pub-sub message bus with topic creation
resource "aws_sns_topic" "tf-sns-topic" {
  name = "ce7_lcchua-tf-sns1"
}

# Create SNS-SQS subscription
resource "aws_sns_topic_subscription" "tf-sns-sqs-subscription" {
  topic_arn = aws_sns_topic.tf-sns-topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.tf_queue.arn
}

# Create SNS-SQS subscription
resource "aws_sns_topic_subscription" "tf-sns-email-subscription" {
  topic_arn = aws_sns_topic.tf-sns-topic.arn
  protocol  = "email"
  endpoint  = "laichwang@gmail.com"
}

# Granting SQS permission to consumer messages from SNS
resource "aws_sqs_queue_policy" "tf-sqs-policy" {
  queue_url = aws_sqs_queue.tf_queue.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "sqs:SendMessage"
        Resource = aws_sqs_queue.tf_queue.arn
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_sns_topic.tf-sns-topic.arn
          }
        }
      }
    ]
  })
}