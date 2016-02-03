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
			expect(@subject.foo).to be(Undefined.instance)
		end

		it "should set and get its own properties" do
			@subject.foo = 42;
			expect(@subject.foo).to eql(42)
		end
	end
end
