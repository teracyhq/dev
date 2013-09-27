actions :add, :remove

default_action :add if defined?(:default_action) # Chef > 10.8

attribute :environment_variable,
  :kind_of => String,
  :name_attribute => true
attribute :value,
  :kind_of => String,
  :default => :add

# Default action for Chef <= 10.8
def initialize(*args)
  super
  @action = :add
end
