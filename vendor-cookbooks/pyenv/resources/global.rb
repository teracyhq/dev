actions :create

attribute :pyenv_version, :kind_of => String, :name_attribute => true
attribute :user,          :kind_of => String
attribute :root_path,     :kind_of => String

def initialize(*args)
  super
  @action = :create
end

def to_s
  "#{super} (#{@user || 'system'})"
end
