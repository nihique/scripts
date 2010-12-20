
    echo "FAIL2BAN INSTALL"
    sudo apt-get remove -y --force-yes fail2ban
    sudo rm -f /var/log/fail2ban.log
    sudo apt-get install -y --force-yes fail2ban
    sudo cp ~/code/scripts/jail.conf /etc/fail2ban/jail.conf
    # repairing startup problems in fail2ban client
    echo '
        file     = "/usr/bin/fail2ban-client"
        line1    = "\t\tfor c in cmd:\n"
        line2    = "\t\t\tbeautifier.setInputCmd(c)\n"
        new_line = "\t\t\ttime.sleep(0.1)\n"
        replaced = File.read(file).sub("#{line1}#{line2}", "#{line1}#{new_line}#{line2}")
        File.open(file, "w") { |f| f.write(replaced) } ' > ~/fail2ban-tmp.rb
    rvmsudo ruby ~/fail2ban-tmp.rb
    rm ~/fail2ban-tmp.rb
    sudo /etc/init.d/fail2ban restart
