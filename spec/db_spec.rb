require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/xml_example'


describe 'Validate parsing XML' do
	describe 'monit with XML_TYPE_5_3' do
		before(:all) do
			@server = Server.parse(XML_TYPE_5_3)
		end

		it 'localhostname should be same as in <localhostname>' do
			@server.localhostname.should eql('ks27535.kimsufi.com')
		end

		it 'should have Serverplatform data' do
			sp = @server.serverplatforms.first
    	
    	sp.server_id.should eql 'c0ca02784e2497827de003c276ce7d3f'
    	sp.server_version.should eql '5.1.1'
    	sp.incarnation.should eql '1322226793'
    	sp.server_version.should eql '5.1.1'
    	sp.uptime.should eql 1435
    	sp.poll.should eql 120
    	sp.startdelay.should eql 0
    	sp.controlfile.should eql '/etc/monit/monitrc'

    	sp.name.should eql 'Linux'
    	sp.release.should eql '2.6.34.6-xxxx-grs-ipv6-64'
    	sp.version.should eql '#3 SMP Fri Sep 17 16:06:38 UTC 2010'
   	 	sp.machine.should eql 'x86_64'
    	sp.cpu.should eql 2
    	sp.memory.should eql 2041276
		end

		it 'should have a 3 services' do
			@server.serverplatforms.first.services.count.should eql 3
		end

		describe 'services' do

			it 'should have a TYPE_SYSTEM (type 5) service' do
				@server.serverplatforms.first.services.where(:type => 5).count.should eql 1
			end

			describe 'TYPE_SYSTEM (5)' do
				it 'should have data' do
					service = @server.serverplatforms.first.services.where(:type => 5).first

					service.name.should eql 'ks27535.kimsufi.com'          
					service.type.should eql 5
					service.collected_sec.should eql 1322228143
					service.collected_usec.should eql 48751
					service.status.should eql 0
					service.status_hint.should eql 0
					service.monitor.should eql 1
					service.monitormode.should eql 0
					service.pendingaction.should eql 0
					service.status_message.should eql ''


					service.load_avg01.should eql '0.04'
					service.load_avg05.should eql '0.01'
					service.load_avg15.should eql '0.00'
					service.cpu_user.should eql '1.9'
					service.cpu_system.should eql '0.5'
					service.cpu_wait.should eql '0.2'
					service.memory_percent.should eql '69.4' 
					service.memory_kilobyte.should eql '1417944'
					service.swap_percent.should eql ''
					service.swap_kilobyte.should eql ''
 				end	
			end

			it 'should have a TYPE_PROCESS (type 3) service' do
				@server.serverplatforms.first.services.where(:type => 5).count.should eql 1
			end


			describe 'TYPE_PROCESS (3)' do
				it 'should have service data with a failure' do
					service = @server.serverplatforms.first.services.where(:name => 'postgres').first

					service.name.should eql 'postgres'          
					service.type.should eql 3
					service.collected_sec.should eql 1322228173
					service.collected_usec.should eql 53132
					service.status.should eql 4608
					service.status_hint.should eql 0
					service.monitor.should eql 1
					service.monitormode.should eql 0
					service.pendingaction.should eql 0
					service.status_message.should eql 'failed to start'

					
					[:pid, :ppid, :uptime, :children, :memory_percent, 
						:memory_percenttotal, :memory_kilobyte, 
					:memory_kilobytetotal, :cpu_percent, :cpu_percenttotal].each {|field| service[field].should eql ""}
				end

				it 'should have service data' do
					service = @server.serverplatforms.first.services.where(:name => 'mailman').first

					service.name.should eql 'mailman'          
					service.type.should eql 3
					service.collected_sec.should eql 1322228173
					service.collected_usec.should eql 53221
					service.status.should eql 0
					service.status_hint.should eql 0
					service.monitor.should eql 1
					service.monitormode.should eql 0
					service.pendingaction.should eql 0
					service.status_message.should eql ''

					
					service[:pid].should eql "5916"
					service[:ppid].should eql "1"
					service[:uptime].should eql "5711945"
					service[:children].should eql "8"
					service[:memory_percent].should eql '0.1'
					service[:memory_percenttotal].should eql '3.6'
					service[:memory_kilobyte].should eql "2436"
					service[:memory_kilobytetotal].should eql "74136"
					service[:cpu_percent].should eql "0.0"
					service[:cpu_percenttotal].should eql "0.0"
				end

			end
		end


		after(:all) do
			@server.delete
		end

	end

end


describe 'Validate parsing JSON' do
	describe 'collector' do
		before(:each) do
			@data = { :server => 'server_name',
								:timestamp => '2011-11-24 13:18:12 +0100',
								:domain => 'domain_name',
								:type => 'type_name',
								:dataset => { :data1 => 'data1', :data2 => 'data2', :data3 => 'data3' }
							}.to_json 
		
			@server = Server.parse_json(@data, '10.10.10.10')
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
			
			server = Server.parse_json(@data2, '10.10.10.10')
			server.collectors.first.datasets.first.data1.should eql  Time.parse("2011-11-24 13:18:12 +0100")
		end

		after(:each) do
			@server.delete
		end
	end
end