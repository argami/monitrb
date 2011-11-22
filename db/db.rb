Mongoid.load!("mongoid.yml")

class Server
  include Mongoid::Document
	field :localhostname, type: String

	has_many :serverplatforms, dependent: :delete
	has_many :services, dependent: :delete
	has_many :events, dependent: :delete


	class << self
		def parse(xml)
			doc = Nokogiri::XML(xml)
			server = Server.find_or_create_by(localhostname: doc.xpath('//server/localhostname').first.content)
			sp = server.serverplatforms.new
			sp.new_parse(doc)
			doc.xpath('//service').each do |service|
				Service.new_parse(server, service)
			end
			doc.xpath('//event').each do |event|
				Service.new_parse(server, event)
			end
			sp.save()
		end
	end
end

class Serverplatform
  include Mongoid::Document
	
	belongs_to :server

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

	def new_parse(doc)
		self.uptime  = doc.xpath('//server/uptime').first.content
		self.poll = doc.xpath('//server/poll').first.content
		self.startdelay = doc.xpath('//server/startdelay').first.content
		self.controlfile = doc.xpath('//server/controlfile').first.content

		self.name = doc.xpath('//platform/name').first.content
		self.release = doc.xpath('//platform/release').first.content
		self.version = doc.xpath('//platform/version').first.content
		self.machine = doc.xpath('//platform/machine').first.content
		self.cpu = doc.xpath('//platform/cpu').first.content
		self.memory = doc.xpath('//platform/memory').first.content
		self.swap = doc.xpath('//platform/swap').first.content
	end
end

class Service 
  include Mongoid::Document
	
	belongs_to :server

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

	class << self
	  def new_parse(server, ser)
		  service = server.services.new
			service.name = ser['name']
			service.type = ser.xpath('//type').first.content
			service.collected_sec = ser.xpath('//collected_sec').first.content
			service.collected_usec = ser.xpath('//collected_usec').first.content
			service.status = ser.xpath('//status').first.content
			service.status_hint  = ser.xpath('//status_hint').first.content
			service.monitor = ser.xpath('//monitor').first.content
			service.monitormode = ser.xpath('//monitormode').first.content
			service.pendingaction = ser.xpath('//pendingaction').first.content
			service.status_message = ser.xpath('//status_message').first.content
			service.save
		end
	end	
end

class Event 
  include Mongoid::Document
	
	belongs_to :server

	field :collected_sec, type: Integer
	field :collected_usec, type: Integer
	field :service, type: String
	field :type, type: Integer
	field :id, type: Integer
	field :state, type: Integer
	field :action, type: Integer
	field :message, type: String

	class << self
	  def new_parse(server, _event)
			event = server.events.new
			event.collected_sec = _event.xpath('collected_sec').first.content
			event.collected_usec = _event.xpath('collected_usec').first.content
			event.service = _event.xpath('service').first.content
			event.type = _event.xpath('type').first.content
			event.id = _event.xpath('id').first.content
			event.state = _event.xpath('state').first.content
			event.action = _event.xpath('action').first.content
			event.message = _event.xpath('message').first.content
			event.save
		end
	end	
end
