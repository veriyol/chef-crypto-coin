# Download, compile and configure the cryptocoin
crypto_coin "bitcoin" do
  url "https://bitcoin.org/bin/bitcoin-core-0.11.2/bitcoin-0.11.2-linux64.tar.gz"
  port 8333
  rpcport 18332
  rpcpassword "1234"
  checksum '2fc13c64fd10b7f75aa93d1f1df78f353a02cca62e17f9ffd106527da2e8b908'
end

# Start the cryptocoin node
service "bitcoind" do
  provider Chef::Provider::Service::Upstart
  action :start
end
