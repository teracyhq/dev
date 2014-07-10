actions :run

attribute :name,      :kind_of => String, :name_attribute => true
attribute :user,      :kind_of => String
attribute :root_path, :kind_of => String

def initialize(*args)
  super
  @action = :run
end
