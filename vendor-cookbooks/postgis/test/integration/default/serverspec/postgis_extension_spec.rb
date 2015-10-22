require 'spec_helper'

describe "PostGIS Extension" do
  get_postgis_version =<<-CMD
su - postgres -c 'psql --user postgres -d template_postgis -c "select PostGIS_Full_Version();"'
  CMD

  describe command(get_postgis_version) do
    it { should return_exit_status 0 }
    it { should return_stdout(/POSTGIS=/) }
  end
end
