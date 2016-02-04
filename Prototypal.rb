class Prototypal
	def initialize(prototype)
		@proto = prototype
		@props = Hash.new
	end

	def create_object
		Prototypal.new(self)
	end

	def proto
		@proto
	end

	def method_missing(method_sym, *arguments, &block)
		ok, value = try_set(method_sym, arguments)
		if ok
			return value
		end

		ok, value = try_get(method_sym, arguments)
		if ok
			return maybe_call(value, arguments)
		end

		if @proto
			@proto.__send__(method_sym, *arguments, &block)
		else
			Undefined.value
		end
	end

	def respond_to?(method_sym, include_private = false)
		true
	end


	private

	def maybe_call(value, arguments)
		if value.respond_to?(:call)
			instance_exec(*arguments, &value)
		else
			value
		end
	end

	def is_setter(method_sym)
		s = method_sym.inspect
		s.start_with?(":") && s.end_with?("=")
	end

	def try_set(method_sym, *arguments)
		if is_setter(method_sym) && arguments.length == 1
			s = method_sym.inspect
			key = s[1, s.length - 2]
			@props[key] = arguments[0][0]
			[true, arguments[0]]
		else
			[false, nil]
		end
	end

	def try_get(method_sym, arguments)
		s = method_sym.inspect
		key = s[1, s.length - 1]
		if @props.has_key?(key)
			[true, @props[key]]
		else
			[false, nil]
		end
	end
end

class Undefined
	@@value = Undefined.new

	def self.value
		@@value
	end
end
