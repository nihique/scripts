#!/bin/bash 

# INPUT PARS
# ==========

param=$1

if [ "$param" = "ROOT" ]
then
    # ROOT SCRIPT
    # ===========
    # ssh root@178.79.142.93
    # scp martin@nihiq.selfip.com:~/code/scripts/linode_setup.sh ~/
    # chmod 777 linode_setup.sh

    echo "adding new user 'martin'"
    adduser martin --ingroup sudo

    echo "changing hostname"
    cp /etc/hostname /etc/hostname.backup
    echo "nhqlinode" > /etc/hostname
    hostname -F /etc/hostname    

    echo "changing hosts file"
    cp /etc/hosts /etc/hosts.backup
    echo "# Custom setup
178.79.142.93   nhqlinode.example.com       nhqlinode
127.0.0.1       localhost.localdomain       localhost
127.0.1.1       nhqlinode
::1 nhqlinode localhost6.localdomain6 localhost6

# The following lines are desirable for IPv6 capable hosts
::1 localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts" > /etc/hosts

   echo "done"

elif [ "$param" = "USER" ]
then
    # USER SCRIPT
    # ===========
    # ssh martin@178.79.142.93

    # distro update
    sudo apt-get update -y
    sudo apt-get upgrade -y --show-upgraded

    # change the timezone
    sudo ln -sf /usr/share/zoneinfo/Europe/Prague /etc/localtime 

    # install htop - monitoring tool
    sudo apt-get install -y --force-yes htop

    # GIT INSTALL
    sudo apt-get install -y --force-yes git git-doc
    # Transfer all SSH keys
    scp nihiq.selfip.com:~/.ssh/* ~/.ssh
    # Transfer git configuration
    scp nihiq.selfip.com:~/.gitconfig ~/
    git config --global core.editor vim
    
    # DOTFILES FROM GITHUB
    git clone git@github.com:nihique/dotfiles.git ~/code/dotfiles
    cp -r ~/code/dotfiles/.git-completion.sh ~/
    cp -r ~/code/dotfiles/.bashrc ~/
    cp -r ~/code/dotfiles/.vimrc ~/
    cp -r ~/code/dotfiles/.vim ~/.vim

    # SCRIPTS FROM GITHUB
    git clone git@github.com:nihique/scripts.git ~/code/scripts

    # FAIL2BAN
    sudo apt-get install -y --force-yes fail2ban
    sudo cp ~/code/scripts/jail.conf /etc/fail2ban/jail.conf
    sudo /etc/init.d/fail2ban restart

    # RVM INSTALL
    bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )
    source ~/.bashrc
    type rvm | head -1
    source ~/.rvm/scripts/rvm
    type rvm | head -1
    rvm notes

    echo "Installing rvm, rubies, gems and rails..."
    sudo apt-get install -y --force-yes build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf
    rvm install 1.9.2
    rvm use 1.9.2 --default
    rvm info
    gem update --system
    gem install rails
    gem install sqlite3-ruby

    echo "Installing passenger and nginx..."
    gem install passenger
    sudo apt-get install -y --force-yes libcurl4-openssl-dev
    rvmsudo passenger-install-nginx-module
    rvmsudo passenger start --port=80 --user=martin --environment=production --daemonize 
    rvmsudo passenger stop --port=80
    wget http://library.linode.com/web-servers/nginx/installation/reference/init-deb.sh
    sudo mv init-deb.sh /etc/init.d/nginx
    sudo chmod +x /etc/init.d/nginx
    sudo /usr/sbin/update-rc.d -f nginx defaults
    sudo /etc/init.d/nginx start

    echo "Installing rails test website..."
    mkdir ~/srv
    cd ~/srv
    rails new rails_test
    cd ~/rails_test
    bundle install
    bundle update
    cd ~/
    sudo sh -c 'echo "worker_processes  1;

events {
    worker_connections  1024;
}

http {
    passenger_root /home/martin/.rvm/gems/ruby-1.9.2-p0/gems/passenger-3.0.2;
    passenger_ruby /home/martin/.rvm/wrappers/ruby-1.9.2-p0/ruby;

    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    server {
        listen 80;
        server_name localhost;
        root /home/martin/srv/rails_test/public;
        passenger_enabled on;
        rails_env development;
    }
}" > /opt/nginx/conf/nginx.conf'
    sudo /etc/init.d/nginx restart



 
else
    echo "No parameter given, nothing done..."
    echo "  usage: ./linode_setup.sh ROOT|USER"
fi
