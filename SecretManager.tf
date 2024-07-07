resource "aws_secretsmanager_secret" "db_secret" {
  name = "postgres-db-secret"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = aws_db_instance.postgresDB.username
    password = "your_actual_password_here" # Replace with your actual database password
  })
}
resource "aws_db_instance_role_association" "postgresSecret" {
  db_instance_identifier = aws_db_instance.postgresDB.id
  role_arn               = aws_iam_role.secret_manager_role.arn
  feature_name = "password for db"
}