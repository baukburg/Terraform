az network vnet-gateway create -n CSRMCGateway -l eastus2 --public-ip-address MCGatewayPubIP -g csr1000v_rg --vnet csr1000v_vnet1 --gateway-type Vpn --sku VpnGw1 --vpn-type RouteBased --no-wait
