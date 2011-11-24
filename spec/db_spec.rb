require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/xml_example'

describe 'Validate parsing' do
	describe 'monit' do
		it 'localhostname should be same as in <localhostname>' do
			server = Server.parse(EVENT_XML)
			server.localhostname.should eql('ks27535.kimsufi.com')
		end
	end

	describe 'collector' do
		before(:each) do
			@data = { :server => 'server_name',
								:timestamp => '2011-11-24 13:18:12 +0100',
								:domain => 'domain_name',
								:type => 'type_name',
								:request_ip => '10.10.10.10',
								:dataset => { :data1 => 'data1', :data2 => 'data2', :data3 => 'data3' }
							}.to_json 
		
			@server = Server.parse_json(@data)
		end

		it 'localhostname should be as server' do
			@server.localhostname.should eql('server_name')
		end

		it 'should create a Collector with ' do
			@server.collectors.count.should eql 1
			coll = @server.collectors.first
			coll.timestamp.should eql '2011-11-24 13:18:12 +0100'
			coll.domain.should eql 'domain_name'
			coll.request_ip.should eql '10.10.10.10'
			coll.type.should eql 'type_name'
			coll.request.should eql @data
		end

		it 'should create a dataset with the info' do
			@server.collectors.first.datasets.count.should eql 1
			ds = @server.collectors.first.datasets.first
			ds["data1"].should eql 'data1'
			ds["data2"].should eql 'data2'
			ds["data3"].should eql 'data3'
		end

		it 'try D() function' do
			D('2011-11-24 18:45:13 UTC').should eql Time.parse('2011-11-24 18:45:13 UTC')
			D('2011-11-24T13:12:31Z').should eql Time.parse('2011-11-24 13:12:31 UTC')	
		end

		it 'try D() function with eval' do
			eval("D('2011-11-24 18:45:13 UTC')").should eql Time.parse('2011-11-24 18:45:13 UTC')
			eval("D('2011-11-24T13:12:31Z')").should eql Time.parse('2011-11-24 13:12:31 UTC')	
		end

		it 'validate if is a function' do
			is_function?('D()').should be_true
			is_function?('D').should be_false
			is_function?('T(').should be_false
			is_function?('T()').should be_true

		end

		it 'should save with date' do
			@data2 = { :server => 'server_name',
								:dataset => { :data1 => "D('2011-11-24 13:18:12 +0100')" }
							}.to_json 
			
			server = Server.parse_json(@data2)
			server.collectors.first.datasets.first.data1.should eql  Time.parse("2011-11-24 13:18:12 +0100")
		end

		after(:each) do
			@server.delete
		end
	end
end