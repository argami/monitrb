def value(doc, xpath)
	x = doc.xpath(xpath)
	if x.count > 0 then
		x.first.content
	else
		""
	end
end




class Server
  include Mongoid::Document
  include Mongoid::Timestamps

	field :localhostname, type: String
	
	index :created_at
	index :localhostname

	has_many :serverplatforms, dependent: :delete
	has_many :collectors, dependent: :delete

	class << self
		def parse(xml, ip)
			doc = Nokogiri::XML(xml)
			server = Server.find_or_create_by(localhostname: doc.xpath('//server/localhostname').first.content)
			server.save
			sp = server.serverplatforms.new(:xml => xml)
			sp.request_ip = ip
			sp.save
			sp.new_parse(doc)
			doc.xpath('//service').each do |service|
				Service.new_parse(sp, service) if !service['type'].blank? or !value(service, 'type').blank?
			end
			doc.xpath('//event').each do |event|
				Event.new_parse(sp, event)
			end
			sp.save()

			server
		end

		def parse_json(json, ip)
			data = json_parse(json)
			server = Server.find_or_create_by(localhostname: data['server'])
			coll = server.collectors.new
			coll.timestamp = data['timestamp']
			coll.type = data['type']
			coll.request_ip = ip
			coll.domain = data['domain']
			coll.request = json
			coll.save
			
			ds = coll.datasets.new 
			data['dataset'].each {|k,v| ds[k] = evaluate(v) }
			ds.save
			
			server.save
			server
		end
	end

	def system
		self.serverplatforms.order_by([:created_at, :desc]).first.services.where(:type => ServiceTypes::TYPE_SYSTEM).first
	end

	def filesystems
		#self.serverplatforms.last.services.where(:type => ServiceTypes::TYPE_SYSTEM)
		[]
	end

	def processes
		self.serverplatforms.order_by([:created_at, :desc]).first.services.where(:type => ServiceTypes::TYPE_PROCESS)
	end

	def hosts
		self.serverplatforms.order_by([:created_at, :desc]).first.services.where(:type => ServiceTypes::TYPE_HOST)
	end

end


class Collector
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :server

  field :timestamp
  field :type
  field :request_ip
  field :request
  field :domain

  has_many :datasets

end

class	Dataset
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :collector
end




class Serverplatform
  include Mongoid::Document
  include Mongoid::Timestamps
	
	belongs_to :server, index: true

	embeds_many :services
	has_many :events, dependent: :delete

	field :request_ip, type: String
	field :monit_id, type: String
	field :incarnation, type: String
	field :server_version, type: String
	field :uptime, type: Integer
	field :poll, type: Integer
	field :startdelay, type: Integer
	field :controlfile, type: String

	field :name, type: String
	field :release, type: String
	field :version, type: String
	field :machine, type: String
	field :cpu, type: Integer
	field :memory, type: Integer
	field :swap, type: Integer

	field :xml

	def new_parse(doc)
		self.monit_id  = value(doc,'//server/id') || doc['id']
		self.incarnation  = value(doc,'//server/incarnation') || doc['incarnation']
		self.server_version  = value(doc,'//server/version') || doc['version']
		self.uptime  = 	value(doc,'//server/uptime')
		self.poll = value(doc,'//server/poll')
		self.startdelay = value(doc, '//server/startdelay')
		self.controlfile = value(doc, '//server/controlfile')

		self.name = value(doc, '//platform/name')
		self.release = value(doc, '//platform/release')
		self.version = value(doc, '//platform/version') 
		self.machine = value(doc,'//platform/machine')
		self.cpu = value(doc, '//platform/cpu')
		self.memory = value(doc,'//platform/memory')
		self.swap = value(doc,'//platform/swap')
	end
end


##############################################
#
# types:
# 		define TYPE_FILESYSTEM    0
# 		define TYPE_DIRECTORY     1
# 		define TYPE_FILE          2
# 		define TYPE_PROCESS       3
# 		define TYPE_HOST          4
# 		define TYPE_SYSTEM        5
# 		define TYPE_FIFO          6
# 		define TYPE_PROGRAM       7
#
##############################################

module ServiceTypes
	TYPE_FILESYSTEM = 0
	TYPE_DIRECTORY  = 1
	TYPE_FILE       = 2
	TYPE_PROCESS    = 3
	TYPE_HOST       = 4
	TYPE_SYSTEM     = 5
	TYPE_FIFO       = 6
	TYPE_PROGRAM    = 7
end


class Service 
  include Mongoid::Document
  include Mongoid::Timestamps
	
	embedded_in :serverplatform

	field :name, type: String
	field :type, type: Integer
	field :collected_sec, type: Integer
	field :collected_usec, type: Integer
	field :status, type: Integer
	field :status_hint, type: Integer
	field :monitor, type: Integer
	field :monitormode, type: Integer
	field :pendingaction, type: Integer
	field :status_message, type: String
	
	index :type

	                      
	#TYPE_FILE - TYPE_FIFO - TYPE_DIRECTORY
	def file_fifo_dir(xml)
		self[:timestamp] = value(xml, '//timestamp')
	end

  def file_dir_filesys_fifo(xml)
    self[:mode] = value(xml, '//mode')
    self[:uid] = value(xml, '//uid')
    self[:gid] = value(xml, '//gid')
  end

	#TYPE_HOST  - TYPE_PROCESS
  def host_process(xml)
		self[:port_hostname] = value(xml, '//port/hostname')
		self[:port_portnumber] = value(xml, '//port/portnumber')
		self[:port_request] = value(xml, '//port/request')
		self[:port_protocol] = value(xml, '//port/protocol')
		self[:port_type] = value(xml, '//port/type')
		self[:port_responsetime] = value(xml, '//port/responsetime')

		self[:unix_path] = value(xml, '//unix/path')
		self[:unix_protocol] = value(xml, '//unix/protocol')
		self[:unix_responsetime] = value(xml, '//unix/responsetime')
  end

  
	# TYPE FILESYSTEM = 0
  def filesystem(xml)
  	self.file_dir_filesys_fifo(xml)

  	self[:flags] = value(xml, '//block/flags')
  	self[:block_percent] = value(xml, '//block/percent') 
  	self[:block_usage] = value(xml, '//block/usage')
  	self[:block_total] = value(xml, '//block/total')
  	self[:inode_percent] = value(xml, '//inode/percent')
  	self[:inode_usage] = value(xml, '//inode/usage')
  	self[:inode_total] = value(xml, '//inode/total')    	
  end

  # TYPE_DIRECTORY = 1
  def directory(xml)
  	self.file_fifo_dir(xml)
  	self.file_dir_filesys_fifo(xml)
  end

	# TYPE_FILE = 2
	def file(xml)
		self.file_dir_filesys_fifo(xml)
		self.file_fifo_dir(xml)

		self[:size] = value(xml, '//size')
		self[:checksum] = value(xml, '//checksum')
	end
	
	#TYPE PROCESS = 3
	def monit_process(xml)
		self.host_process(xml)

		self[:pid] = value(xml, 'pid')
		self[:ppid] = value(xml, 'ppid')
		self[:uptime] = value(xml, 'uptime')
		self[:children] = value(xml, 'children')
		self[:memory_percent] = value(xml, 'memory/percent')
		self[:memory_percenttotal] = value(xml, 'memory/percenttotal')
		self[:memory_kilobyte] = value(xml, 'memory/kilobyte')
		self[:memory_kilobytetotal] = value(xml, 'memory/kilobytetotal')
		self[:cpu_percent] = value(xml, 'cpu/percent')
		self[:cpu_percenttotal] = value(xml, 'cpu/percenttotal')
	end

	# TYPE HOST = 4
	def host(xml)
		self.host_process(xml)

	  self[:icmp_type] = value(xml, '//icmp/type')
	  self[:icmp_responsetime] = value(xml, '//icmp/responsetime')
	end

	#TYPE SYSTEM = 5     
	#SYSTEM/***/***
	def system(xml)
		self[:load_avg01] = value(xml, 'system/load/avg01')
		self[:load_avg05] = value(xml, 'system/load/avg05')
		self[:load_avg15] = value(xml, 'system/load/avg15')
		self[:cpu_user] = value(xml, 'system/cpu/user')
		self[:cpu_system] = value(xml, 'system/cpu/system')
		self[:cpu_wait] = value(xml, 'system/cpu/wait')
		self[:memory_percent] = value(xml, 'system/memory/percent')
		self[:memory_kilobyte] = value(xml, 'system/memory/kilobyte')
		self[:swap_percent] = value(xml, 'system/swap/percent')
		self[:swap_kilobyte] = value(xml, 'system/swap/kilobyte')
	end

	#TYPE FIFO = 6
	def fifo(xml)
		self.file_dir_filesys_fifo(xml)
		self.file_fifo_dir(xml)
	end

	# TYPE PROGRAM = 7
	# program/**
	def program(xml)
		self[:program_started] = value(xml, '//program/started')
		self[:program_status] = value(xml, '//program/status')
	end

	class << self
	  def new_parse(server, ser)
			service = server.services.new
			service.name = ser['name'] || value(ser, 'name')
			service.type = ser['type'] || value(ser, 'type')
			service.collected_sec = value(ser, 'collected_sec')
			service.collected_usec = value(ser, 'collected_usec')
			service.status = value(ser, 'status')
			service.status_hint  = value(ser, 'status_hint')
			service.monitor = value(ser, 'monitor')
			service.monitormode = value(ser, 'monitormode')
			service.pendingaction = value(ser, 'pendingaction')
			service.status_message = value(ser, 'status_message')


			case service.type
				when ServiceTypes::TYPE_FILESYSTEM then service.filesystem(ser)
				when ServiceTypes::TYPE_DIRECTORY then service.directory(ser) 
				when ServiceTypes::TYPE_FILE then service.file(ser)      
				when ServiceTypes::TYPE_PROCESS then service.monit_process(ser)
				when ServiceTypes::TYPE_HOST then service.host(ser)      
				when ServiceTypes::TYPE_SYSTEM then service.system(ser)    
				when ServiceTypes::TYPE_FIFO then service.fifo(ser)      
				when ServiceTypes::TYPE_PROGRAM  then service.program(ser)
			else
				puts "Unrecognize type: #{service.type}" 
			end
			service.save
		end
	end	

	# def method_missing(m, *args, &block)  
 #    ""
 #  end
end

class Event 
  include Mongoid::Document
  include Mongoid::Timestamps
	
	belongs_to :serverplatform, index: true

	field :collected_sec
	field :collected_usec
	field :service
	field :type
	field :event_id
	field :state
	field :action
	field :message

	class << self
	  def new_parse(server, _event)
			event = server.events.new
			event.collected_sec = value(_event, '//collected_sec')
			event.collected_usec = value(_event, '//collected_usec')
			event.service = value(_event, '//service')
			event.type = value(_event, '//type')
			event.event_id = value(_event, '//id')
			event.state = value(_event, '//state')
			event.action = value(_event, '//action')
			event.message = value(_event, '//message')
			event.save
		end
	end	
end
