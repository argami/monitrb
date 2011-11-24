
#Convert date

def D(_date)
	Time.parse(_date)
end


# detect if is a function
def is_function?(data)
	/.\(.*\)/.match(data)? true :false
end

def evaluate(data)
	if is_function?(data)
	  eval(data)
	else
		data
	end
end