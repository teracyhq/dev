actions :install, :reinstall

attribute :version,     :kind_of => String, :name_attribute => true
attribute :root_path,   :kind_of => String
attribute :user,        :kind_of => String
attribute :environment, :kind_of => Hash

def initialize(*args)
  super
  @action = :install
  @pyenv_version = @version
end

def to_s
  "#{super} (#{@user || 'system'})"
end
