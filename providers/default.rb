# Support whyrun
def whyrun_supported?
  true
end

action :install do
  set_default_attributes

  user(new_resource.user) do
    comment       new_resource.name.capitalize
    home          new_resource.home
    shell         "/bin/bash"
    supports      :manage_home => true
  end

  directory(@new_resource.clone_path) do
    recursive true
  end

  remote_file '/tmp/archive.tar.gz' do
    source new_resource.url
    mode '0755'
    checksum new_resource.checksum
  end

  execute 'extract_some_tar' do
    command 'tar xzvf /tmp/archive.tar.gz'
    cwd new_resource.clone_path
  end

  conf_file = ::File.join(new_resource.home, "#{new_resource.name}.conf")

  link ::File.join(new_resource.home, new_resource.executable) do
    to            ::File.join(new_resource.clone_path, 'bin', new_resource.executable)
    owner         new_resource.user
    group         new_resource.group
  end

  directory new_resource.data_dir do
    owner         new_resource.user
    group         new_resource.group
    mode          0700
  end

  file conf_file do
    owner         new_resource.user
    group         new_resource.group
    mode          0440
    content       config_content
  end

  template "/etc/init/#{new_resource.executable}.conf" do
    source        "upstart.conf.erb"
    mode          0644
    cookbook      "crypto-coin"
    variables(
      :user => new_resource.user,
      :group => new_resource.group,
      :data_dir => new_resource.data_dir,
      :conf_path => conf_file,
      :executable_name => new_resource.executable,
      :executable_path => ::File.join(new_resource.home, new_resource.executable),
      :autostart => new_resource.autostart,
      :respawn_times => new_resource.respawn_times,
      :respawn_seconds => new_resource.respawn_seconds
    )
  end
end

def set_default_attributes
  @new_resource.user(@new_resource.user || @new_resource.name)
  @new_resource.group(@new_resource.group || @new_resource.name)
  @new_resource.home(@new_resource.home || ::File.join('/home', @new_resource.name))
  @new_resource.executable(@new_resource.executable || "#{@new_resource.name}d")
  @new_resource.clone_path(@new_resource.clone_path || ::File.join('/opt', 'crypto_coins', @new_resource.name))
  @new_resource.data_dir(@new_resource.data_dir || ::File.join(@new_resource.home, 'data'))
  @new_resource.autostart(@new_resource.autostart)
  @new_resource.respawn_times(@new_resource.respawn_times)
  @new_resource.respawn_seconds(@new_resource.respawn_seconds)
end

def config_hash
  @new_resource.conf['rpcpassword'] = @new_resource.rpcpassword
  @new_resource.conf['rpcport'] = @new_resource.rpcport
  @new_resource.conf['port'] = @new_resource.port
  @new_resource.conf['checksum'] = @new_resource.checksum

  # Connect to IRC for peer discovery
  @new_resource.conf['irc'] = 1
  # Set rpc user is "{coin}_user"
  @new_resource.conf['rpcuser'] = "admin"
  return @new_resource.conf
end

def config_content
  content = ""
  config_hash.each do |key, value|
    case value
    when Array
      value.each do |part|
        content << "#{key}=#{part}\n"
      end
    when NilClass
      # do nothing
    else
      content << "#{key}=#{value}\n"
    end
  end
  return content
end
