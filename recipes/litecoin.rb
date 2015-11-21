# Example recipe that uses the LWRP to install litecoind

# Get access to the LWRP and install prerequisites
include_recipe "crypto-coin::default"

# Download, compile and configure the cryptocoin
crypto_coin "litecoin" do
  repository    "https://github.com/litecoin-project/litecoin/archive/v0.10.2.2.tar.gz"
  port          9333
  rpcpassword   "nojxxq2rryghg1p0ti7x"
end

# Start the cryptocoin node
service "litecoind" do
  provider Chef::Provider::Service::Upstart
  action :start
end
