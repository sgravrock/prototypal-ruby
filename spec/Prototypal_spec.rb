require './Prototypal'

describe Prototypal do
	describe "Getting property values" do
		context "From the root object" do
			before do
				@subject = Prototypal.new(nil)
			end
	
			it "should not have a prototype" do
				expect(@subject.proto).to be_nil
			end
	
			it "should return Undefined when an unset property is read" do
				expect(@subject.foo).to be(Undefined.value)
			end
	
			it "should get its own properties" do
				@subject.foo = 42;
				expect(@subject.foo).to eql(42)
			end
		end

		context "From an object with a prototype" do
			before do
				@root = Prototypal.new(nil)
				@subject = @root.create_object
			end
	
			it "should have a prototype" do
				expect(@subject.proto).to be(@root)
			end
	
			it "should get its own properties" do
				@subject.foo = 42;
				expect(@subject.foo).to eql(42)
			end
	
			it "should return Undefined when an unset property is read" do
				expect(@subject.foo).to be(Undefined.value)
			end
	
			it "should get missing properties from the prototype" do
				@root.foo = 17;
				expect(@subject.foo).to eql(17)
			end
	
			it "should prefer own properties over the prototype" do
				@root.foo = 17;
				@subject.foo = 42;
				expect(@subject.foo).to eql(42)
			end
		end
	end

	describe "Setting property values" do
		before do
			@subject = Prototypal.new(nil).create_object
		end
	
		it "should set properties on self, not the prototype" do
			@subject.foo = 17
			expect(@subject.proto.foo).to be(Undefined.value)
			@subject.proto.foo = 42;
			@subject.foo = 18
			expect(@subject.proto.foo).to eql(42)
		end
	end

	describe "Calling 'methods'" do
		before do
			@subject = Prototypal.new(nil)
		end

		describe "With no arguments" do
			it "should call the lambda" do
				called = false
				@subject.foo = lambda { called = true }
				@subject.foo
				expect(called).to eql(true)
			end
		end

		describe "With arguments" do
			it "should call the lambda with the arguments" do
				v1 = nil
				v2 = nil
				@subject.foo = lambda do |a, b|
					v1 = a
					v2 = b
				end
				@subject.foo(4, 5)
				expect(v1).to eql(4)
				expect(v2).to eql(5)
			end
		end

		it "should return the value returned by the lambda" do
			@subject.foo = lambda { "yo" }
			expect(@subject.foo).to eql("yo")
		end

		it "should set self to the object the method was called on" do
			instance = nil
			@subject.foo = lambda { instance = self }
			@subject.foo
			expect(instance).to be(@subject)
		end

		it "should allow access to other object properties from the lambda" do
			@subject.name = "Bob"
			@subject.foo = lambda { self.name }
			expect(@subject.foo).to eql("Bob")
		end
	end
end
