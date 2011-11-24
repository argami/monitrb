require 'json'
require 'json/ext/parser'

def json_parse(json)
	JSON::Ext::Parser.new(json).parse
end

