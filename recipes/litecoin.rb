# Download, compile and configure the cryptocoin
crypto_coin "litecoin" do
  repository    "https://download.litecoin.org/litecoin-0.10.2.2/linux/litecoin-0.10.2.2-linux64.tar.gz"
  port          9333
  rpcpassword   "nojxxq2rryghg1p0ti7x"
  checksum '136779e717603002f0a3f0da4f48f38274a286171cff10dd68da067ed82c8b26'
end

# Start the cryptocoin node
service "litecoind" do
  provider Chef::Provider::Service::Upstart
  action :start
end
