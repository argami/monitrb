Description
===========

Monitrb is a [m/monit](http://mmonit.com/monit/) event collector which works on Sinatra and mongodb

Installation
============

<pre>
% git clone 
% bundle install
</pre>

- Change the password and username in the monitrb.rb
- Change the mongodb connection in db.rb

start the server
<pre>
% rackup
</pre>

In your monit script add

<pre>
	set mmonit http://user:password@server:port/collector
</pre>

start your monit.


