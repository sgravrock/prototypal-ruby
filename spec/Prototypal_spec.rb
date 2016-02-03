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

	describe "respond_to?" do
		before do
			@subject = Prototypal.new(nil).create_object
		end

		it "responds to messages to get its own properties" do
			@subject.foo = 17
			expect(@subject.respond_to?(:foo)).to eql(true)
		end

		it "responds to messages to get its prototype's properties" do
			@subject.proto.foo = 17
			expect(@subject.respond_to?(:foo)).to eql(true)
		end

		it "does not respond to messages to get unset properties" do
			expect(@subject.respond_to?(:foo)).to eql(false)
		end

		it "responds to all setters" do
			@subject.foo = 17
			expect(@subject.respond_to?(:foo=)).to eql(true)
			expect(@subject.respond_to?(:bar=)).to eql(true)
		end
	end
end
