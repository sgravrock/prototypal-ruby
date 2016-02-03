require './Prototypal'

describe Prototypal do
	context "The root object" do
		before do
			@subject = Prototypal.new(nil)
		end

		it "should not have a prototype" do
			expect(@subject.proto).to be_nil
		end

		it "should return Undefined when an unset property is read" do
			expect(@subject.foo).to be(Undefined.value)
		end

		it "should set and get its own properties" do
			@subject.foo = 42;
			expect(@subject.foo).to eql(42)
		end
	end

	context "Objects with prototypes" do
		before do
			@root = Prototypal.new(nil)
			@subject = @root.create_object
		end

		it "should have a prototype" do
			expect(@subject.proto).to be(@root)
		end

		it "should set and get its own properties" do
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

		it "should set missing properties on self, not the prototype" do
			@subject.foo = 17
			expect(@root.foo).to be(Undefined.value)
		end

		it "responds to messages to get its own properties" do
			@subject.foo = 17
			expect(@subject.respond_to?(:foo)).to eql(true)
		end

		it "responds to messages to get its prototype's properties" do
			@root.foo = 17
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
