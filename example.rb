require './Prototypal'

root = Prototypal.new(nil)

person = root.create_object
person.name = "An anonymous person"
person.describe = lambda { |p| print "#{p.name} is in the room.\n" }

ninja = person.create_object
ninja.describe = lambda { |p| }

alice = person.create_object
alice.name = "Alice"
bob = person.create_object
bob.name = "Bob"
craig = ninja.create_object
craig.name = "Craig"

[alice, bob, craig].each do |p|
	p.describe.call(p)
end
