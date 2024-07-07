variable "myregion" {
  type    = string
  default = "us-east-1"

}
variable "gatewayIP" {
  type = string

}
variable "DirectConnectLocation" {
  type    = string # use the command : aws directconnect describe-locations      
  default = "EqDC2"

}
variable "myPublicIP" {
  type = string
}