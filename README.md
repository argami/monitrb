Description
===========

Monitrb is a [m/monit](http://mmonit.com/monit/) event collector which works on Sinatra and mongodb

Goals
=====

In the main goal is be able to set a collector for monit information but we want it be easy to use to 
collect any information that we send to the system.

Monit Collection
================

the M/monit portocol sen information over Server, Platform, Services, Events.

In the part of Services they have 8 types of events with diferent data which are:

- FILESYSTEM
- DIRECTORY 
- FILE      
- PROCESS   
- HOST      
- SYSTEM    
- FIFO      
- PROGRAM   

Using a mongodb all the information is saved in the Service collection but with dynamic field for 
the especific data for each type


Collector
=========

There's a internal collector  in the url/collector you can send data with a POST request

<pre>
{ 
	'server' : 'server_name',
  	'timestamp' : '2011-11-24 13:18:12 +0100',
  	'domain' : 'domain_name',
  	'type' : 'type_name',
	'dataset' : { 
					:data1 => 'data1', 
					:data2 => 'data2', 
					:data3 => 'data3' 
				}
}

</pre>


Installation
============

You should have rvm installed.

<pre>
	% git clone 
	% rvm create gemset monitrb
	% bundle install
</pre>

- Change the password and username in the monitrb.rb
- Change the mongodb connection in db.rb

start the server
<pre>
% rackup
</pre>

In your monit script add:

<pre>
	set mmonit http://user:password@server:port/monit/collector
</pre>

Start your monit.


