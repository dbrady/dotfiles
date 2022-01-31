# thing.just_your_methods - Return methods not shared with all Object instances

# Differs from object.methods(false) in that it returns methods you inherit from
# parent classes (that aren't also inherited by Object instances)

class Object
  def just_your_methods
    (self.methods - Object.new.methods).sort
  end
end

puts "Object#just_your_methods loaded."
