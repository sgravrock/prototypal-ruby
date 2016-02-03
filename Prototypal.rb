class Prototypal
	def initialize(prototype)
		@proto = prototype
		@props = Hash.new
		@in_method_missing = false
	end

	def create_object
		Prototypal.new(self)
	end

	def proto
		@proto
	end

	def method_missing(method_sym, *arguments, &block)
		if @in_method_missing
			raise "method_missing recursed!"
		end

		@in_method_missing = true
		result = real_method_missing(method_sym, *arguments, &block)
		@in_method_missing = false
		result
	end

	private

	def real_method_missing(method_sym, *arguments, &block)
		ok, value = try_set(method_sym, arguments)

		if not ok
			ok, value = try_get(method_sym, arguments)
		end

		if ok
			value
		elsif @proto
			@proto.__send__(method_sym, *arguments, &block)
		else
			Undefined.value
		end
	end

	def try_set(method_sym, *arguments)
		s = method_sym.inspect

		if s.start_with?(":") && s.end_with?("=") && arguments.length == 1
			key = s[1, s.length - 2]
			@props[key] = arguments[0][0]
			[true, arguments[0]]
		else
			[false, nil]
		end
	end

	def try_get(method_sym, arguments)
		if arguments.length == 0
			s = method_sym.inspect
			key = s[1, s.length - 1]
			if @props.has_key?(key)
				[true, @props[key]]
			else
				[false, nil]
			end
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
