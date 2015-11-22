# Download, compile and configure the cryptocoin
crypto_coin "litecoin" do
  repository    "https://download.litecoin.org/litecoin-0.10.2.2/linux/litecoin-0.10.2.2-linux64.tar.gz"
  port          9333
  rpcpassword   "nojxxq2rryghg1p0ti7x"
end

# Start the cryptocoin node
service "litecoind" do
  provider Chef::Provider::Service::Upstart
  action :start
end
