case node[:platform]
when "debian","ubuntu"

  directory "/var/cache/local/preseeding" do
    owner "root"
    group "root"
    mode 0755
    recursive true
  end

  execute "preseed-mysql-server" do
    command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
    action :nothing
  end

  template "/var/cache/local/preseeding/mysql-server.seed" do
    source "mysql-server.seed.erb"
    backup false
    owner "root"
    group "root"
    mode "0600"
    notifies :run, resources(:execute => "preseed-mysql-server"), :immediately
  end

  execute "preseed-percona-server" do
    command "debconf-set-selections /var/cache/local/preseeding/percona-server.seed"
    action :nothing
  end

  template "/var/cache/local/preseeding/percona-server.seed" do
    source "percona-server.seed.erb"
    backup false
    owner "root"
    group "root"
    mode "0600"
    notifies :run, resources(:execute => "preseed-percona-server"), :immediately
  end

  template "/etc/mysql/debian.cnf" do
    source "debian.cnf.erb"
    backup false
    owner "root"
    group "root"
    mode "0600"
  end
end