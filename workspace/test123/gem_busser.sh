 yum install gem -y
 gem install busser






dir -p /home/kitchen/.ssh 
chmod 0700 /home/kitchen/.ssh 
touch /home/kitchen/.ssh/authorized_keys 
chmod 0600 /home/kitchen/.ssh/authorized_keys 
chown -R kitchen:kitchen /home/kitchen/.ssh 
install --no-rdoc --no-ri --no-format-executable --bindir /tmp/verifier/bin --no-user-install