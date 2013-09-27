actions :add, :remove

default_action :add if defined?(:default_action) # Chef > 10.8

attribute :alias_name,
  :kind_of => String,
  :name_attribute => true
attribute :command,
  :kind_of => String,
  :default => :add

# Default action for Chef <= 10.8
def initialize(*args)
  super
  @action = :add
end
