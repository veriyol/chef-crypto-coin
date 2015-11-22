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
