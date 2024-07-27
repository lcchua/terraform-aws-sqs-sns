resource "aws_sqs_queue" "terraform_queue" {
  name                      = "ce7-lcchua-tf-sqs2"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Environment = "development"
  }
}
