resource "aws_customer_gateway" "firstvpn" {
  bgp_asn    = 65000
  ip_address = "172.83.124.10"
  type       = "ipsec.1"

  tags = {
    Name = "VPN-Connect1"
  }
}

resource "aws_vpn_gateway" "vpn_gw1" {
  vpc_id = aws_vpc.public-vpc.id

  tags = {
    Name = "for the public subnet"
  }
}

resource "aws_vpn_connection" "AWSVpn1" {
  customer_gateway_id = aws_customer_gateway.firstvpn.id
  vpn_gateway_id      = aws_vpn_gateway.vpn_gw1.id
  type                = aws_customer_gateway.firstvpn.type
}

resource "aws_vpn_gateway" "vpn_gw2" {
  vpc_id = aws_vpc.private-vpc.id

  tags = {
    Name = "for the private subnet"
  }
}

resource "aws_vpn_connection" "AWSVpn2" {
  customer_gateway_id = aws_customer_gateway.firstvpn.id
  vpn_gateway_id      = aws_vpn_gateway.vpn_gw2.id
  type                = aws_customer_gateway.firstvpn.type
}

resource "aws_dx_connection" "DirectConnection" {
  name            = "tf-dx-connection"
  bandwidth       = "10Gbps"
  location        = var.DirectConnectLocation
  request_macsec  = true
  encryption_mode = "must_encrypt"

  tags = {
    Name = "Direct-Connect"
  }
}

resource "aws_dx_gateway" "dx_gateway" {
  name            = "direct-connect"
  amazon_side_asn = "64512"
}

resource "aws_dx_gateway_association" "example_dxgw_association1" {
  dx_gateway_id         = aws_dx_gateway.dx_gateway.id
  associated_gateway_id = aws_vpn_gateway.vpn_gw1.id
}

resource "aws_dx_gateway_association" "example_dxgw_association2" {
  dx_gateway_id         = aws_dx_gateway.dx_gateway.id
  associated_gateway_id = aws_vpn_gateway.vpn_gw2.id
}
