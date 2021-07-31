#!/bin/bash
cp ./blog.conf /etc/apache2/sites-available/blog.conf
cat << EOF >> /etc/apache2/apache2.conf
LoadModule passenger_module /home/rails/.rbenv/versions/2.7.4/lib/ruby/gems/2.7.0/gems/passenger-6.0.10/buildout/apache2/mod_passenger.so
<IfModule mod_passenger.c>
    PassengerRoot /home/rails/.rbenv/versions/2.7.4/lib/ruby/gems/2.7.0/gems/passenger-6.0.10
    PassengerDefaultRuby /home/rails/.rbenv/versions/2.7.4/bin/ruby
</IfModule>
EOF
chmod -x /etc/apache2/sites-available/blog.conf
apt install tzdata