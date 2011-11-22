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

	has_many :serverplatforms, dependent: :delete


	class << self
		def parse(xml)
			doc = Nokogiri::XML(xml)
			server = Server.find_or_create_by(localhostname: doc.xpath('//server/localhostname').first.content)
			sp = server.serverplatforms.new
			sp.xml = xml
			sp.new_parse(doc)
			doc.xpath('//service').each do |service|
				Service.new_parse(sp, service)
			end
			doc.xpath('//event').each do |event|
				Event.new_parse(sp, event)
			end
			sp.save()
		end
	end
end

class Serverplatform
  include Mongoid::Document
  include Mongoid::Timestamps
	
	belongs_to :server
	has_many :services, dependent: :delete
	has_many :events, dependent: :delete

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
		self.uptime  = 		value(doc,'//server/uptime')
		self.poll = 			value(doc,'//server/poll')
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

class Service 
  include Mongoid::Document
  include Mongoid::Timestamps
	
	belongs_to :serverplatform

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
			service.type = value(ser, '//type')
			service.collected_sec = value(ser, '//collected_sec')
			service.collected_usec = value(ser, '//collected_usec')
			service.status = value(ser, '//status')
			service.status_hint  = value(ser, '//status_hint')
			service.monitor = value(ser, '//monitor')
			service.monitormode = value(ser, '//monitormode')
			service.pendingaction = value(ser, '//pendingaction')
			service.status_message = value(ser, '//status_message')
			service.save
		end
	end	
end

class Event 
  include Mongoid::Document
  include Mongoid::Timestamps
	
	belongs_to :serverplatform

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
