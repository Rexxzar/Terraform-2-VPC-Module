resource "aws_storagegateway_gateway" "S3-storage-Gateway" {
  gateway_ip_address = var.gatewayIP
  gateway_name       = "my-s3-gateway"
  gateway_timezone   = "GMT"
  gateway_type       = "FILE_S3"
}

resource "aws_storagegateway_cache" "example" {
  gateway_arn = aws_storagegateway_gateway.S3-storage-Gateway.arn
  disk_id     = "pci-0000:03:00.0-scsi-0:0:0:0" # Replace with actual disk identifier
}

resource "aws_storagegateway_working_storage" "example" {
  gateway_arn = aws_storagegateway_gateway.S3-storage-Gateway.arn
  disk_id     = "pci-0000:03:00.0-scsi-0:0:1:0" # Replace with actual disk identifier
}
