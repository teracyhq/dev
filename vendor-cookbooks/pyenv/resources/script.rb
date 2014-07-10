actions :run

attribute :name,          :kind_of => String, :name_attribute => true
attribute :pyenv_version, :kind_of => String
attribute :root_path,     :kind_of => String
attribute :code,          :kind_of => String
attribute :creates,       :kind_of => String
attribute :cwd,           :kind_of => String
attribute :environment,   :kind_of => Hash
attribute :group,         :kind_of => String
attribute :path,          :kind_of => Array
attribute :returns,       :kind_of => Array, :default => [ 0 ]
attribute :timeout,       :kind_of => Integer
attribute :user,          :kind_of => String
attribute :umask,         :kind_of => String

def initialize(*args)
  super
  @action = :run
end
