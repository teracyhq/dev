require 'json'
require '././lib/teracy-dev/util'

describe 'utility' do
  describe 'overrides' do
    context 'given an empty obj2' do
      it 'returns the same obj1' do
        obj1 = { 'msg' => 'hello' }
        new_obj = TeracyDev::Util.override(obj1, {})
        expect(new_obj).to eql(obj1)
      end
    end

    context 'given a simple obj2' do
      it 'returns the new obj' do
        obj1 = { 'msg' => 'hello' }
        obj2 = { 'a' => 'b' }
        new_obj = TeracyDev::Util.override(obj1, obj2)
        new_obj2 = { 'msg' => 'hello', 'a' => 'b' }
        expect(new_obj).to eql(new_obj2)
      end
    end

    context 'given a simple override obj2' do
      it 'returns the new overriden obj' do
        file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/config.json'
        obj1 = JSON.parse(File.read(file))
        obj2 = {
          'vm' => {
            'box_version' => '1.2.3'
          },
          'vb' => {
            'memory' => 2048
          }
        }
        new_obj = TeracyDev::Util.override(obj1, obj2)
        # puts new_obj
        expect(new_obj['vm']['box_version']).to eql('1.2.3')
        expect(new_obj['vb']['memory']).to eql(2048)
      end
    end

    context 'given a simple obj2 to append by default index' do
      it 'returns the new overriden obj' do
        file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/config.json'
        obj1 = JSON.parse(File.read(file))
        obj2 = {
          'plugins' => [{
            '_id' => '2',
            'name' => 'my-plugin',
            'required' => true
          }]
        }
        new_plugins = TeracyDev::Util.override(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(3)
        expect(new_plugins[2]).to eql(obj2['plugins'][0])
      end
    end

    context 'given a simple obj2 to append by specified index' do
      it 'returns the new overriden obj' do
        file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/config.json'
        obj1 = JSON.parse(File.read(file))
        obj2 = {
          'plugins' => [{
            '_id' => '2',
            '_idx' => 0,
            'name' => 'my-plugin',
            'required' => true
          }]
        }
        new_plugins = TeracyDev::Util.override(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(3)
        expect(new_plugins[0]).to eql(obj2['plugins'][0])
      end
    end

    context 'given a deep level obj2 to append by default index' do
      it 'returns the new overriden obj' do
        obj1 = {
          'provisioners' => [{
            '_id' => '0',
            'type' => 'chef_solo',
            'json' => {
              'teracy-dev' => {
                'directories' => [{
                  '_id' => '0',
                  'path' => '/home/vagrant/workspace',
                  'owner' => 'vagrant',
                  'group' => 'vagrant',
                  'mode' => '0775',
                  'action' => 'create'
                }, {
                  '_id' => '1',
                  'path' => '/home/vagrant/test',
                  'owner' => 'vagrant',
                  'group' => 'vagrant',
                  'mode' => '0775',
                  'action' => 'create'
                }]
              }
            }
          }]
        }
        obj2 = {
          'provisioners' => [{
            '_id' => '0',
            'json' => {
              'teracy-dev' => {
                'directories' => [{
                  '_id': '2',
                  'path' => '/home/vagrant/test2'
                }]
              }
            }
          }]
        }
        new_obj = TeracyDev::Util.override(obj1, obj2)
        new_directories = new_obj['provisioners'][0]['json']['teracy-dev']['directories']
        new_directories2 = obj2['provisioners'][0]['json']['teracy-dev']['directories'][0]
        expect(new_directories.length).to eql(3)
        expect(new_directories[2]).to eql(new_directories2)
      end
    end

    context 'given a deep level obj2 to append by specified index' do
      it 'returns the new overriden obj' do
        obj1 = {
          'provisioners' => [{
            '_id' => '0',
            'type' => 'chef_solo',
            'json' => {
              'teracy-dev' => {
                'directories' => [{
                  '_id' => '0',
                  'path' => '/home/vagrant/workspace',
                  'owner' => 'vagrant',
                  'group' => 'vagrant',
                  'mode' => '0775',
                  'action' => 'create'
                }, {
                  '_id' => '1',
                  'path' => '/home/vagrant/test',
                  'owner' => 'vagrant',
                  'group' => 'vagrant',
                  'mode' => '0775',
                  'action' => 'create'
                }]
              }
            }
          }]
        }
        obj2 = {
          'provisioners' => [{
            '_id' => '0',
            'json' => {
              'teracy-dev' => {
                'directories' => [{
                  '_id': '2',
                  '_idx' => 1,
                  'path' => '/home/vagrant/test2'
                }]
              }
            }
          }]
        }
        new_obj = TeracyDev::Util.override(obj1, obj2)
        new_directories = new_obj['provisioners'][0]['json']['teracy-dev']['directories']
        new_directories1 = obj2['provisioners'][0]['json']['teracy-dev']['directories'][0]
        expect(new_directories.length).to eql(3)
        expect(new_directories[1]).to eql(new_directories1)
      end
    end

    context 'given a simple obj2 to override by default' do
      it 'returns the new overriden obj' do
        file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/config.json'
        obj1 = JSON.parse(File.read(file))
        obj2 = {
          'plugins' => [{
            '_id' => '0',
            'rsync_on_startup' => false
          }]
        }
        new_plugins = TeracyDev::Util.override(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(2)
        expect(new_plugins[0]['rsync_on_startup']).to eql(false)
      end
    end

    context "given a simple obj2 to override by _op='o'" do
      it 'returns the new overriden obj' do
        file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/config.json'
        obj1 = JSON.parse(File.read(file))
        obj2 = {
          'plugins' => [{
            '_id' => '0',
            '_op' => 'o',
            'rsync_on_startup' => false
          }]
        }
        new_plugins = TeracyDev::Util.override(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(2)
        expect(new_plugins[0]['rsync_on_startup']).to eql(false)
      end
    end

    context "given a simple obj2 to override by _op='r'" do
      it 'returns the new overriden obj' do
        file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/config.json'
        obj1 = JSON.parse(File.read(file))
        obj2 = {
          'plugins' => [{
            '_id' => '0',
            '_op' => 'r',
            'rsync_on_startup' => false
          }]
        }
        new_plugins = TeracyDev::Util.override(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(2)
        expect(new_plugins[0]).to eql(obj2['plugins'][0])
      end
    end

    context "given a simple obj2 to override by _op='d'" do
      it 'returns the new overriden obj' do
        file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/config.json'
        obj1 = JSON.parse(File.read(file))
        obj2 = {
          'plugins' => [{
            '_id' => '0',
            '_op' => 'd'
          }]
        }
        new_plugins = TeracyDev::Util.override(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(1)
        new_plugins2 = {
          '_id' => '1',
          'name' => 'vagrant-rsync-back',
          'required' => true
        }
        expect(new_plugins[0]).to eql(new_plugins2)
      end
    end

    context 'given a simple obj2 to replace existing array' do
      it 'returns the new overriden obj' do
        file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/config.json'
        obj1 = JSON.parse(File.read(file))
        obj2 = {
          '_r_plugins' => [{
            '_id' => '0',
            'name' => 'my-plugin',
            'required' => true
          }]
        }
        new_plugins = TeracyDev::Util.override(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(1)
        expect(new_plugins).to eql(obj2['_r_plugins'])
      end
    end

    context 'given a simple obj2 to replace existing text array' do
      it 'returns the new overriden obj' do
        file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/config.json'
        obj1 = JSON.parse(File.read(file))
        obj2 = {
          'provisioners' => [{
            '_id' => '0',
            'run_list' => [
              'my',
              'new',
              'run-list'
            ]
          }]
        }
        new_provisioners = TeracyDev::Util.override(obj1, obj2)['provisioners']
        # puts new_provisioners
        expect(new_provisioners[0]['run_list']).to eql(obj2['provisioners'][0]['run_list'])
      end
    end

    context 'given a simple obj2 to replace existing text array with an empty array' do
      it 'returns the new overriden obj' do
        file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/config.json'
        obj1 = JSON.parse(File.read(file))
        obj2 = {
          'provisioners' => [{
            '_id' => '0',
            'run_list' => []
          }]
        }
        new_provisioners = TeracyDev::Util.override(obj1, obj2)['provisioners']
        # puts new_provisioners
        expect(new_provisioners[0]['run_list']).to eql(obj2['provisioners'][0]['run_list'])
      end
    end
    context 'given an object then override it with another object containing an array' do
      it 'all array name in new and old array must be normalized' do
        obj1 = {}
        obj2 = {
          'provisioners' => [{
            '_id' => '0',
            '_a_run_list' => []
          }]
        }
        new_provisioners = TeracyDev::Util.override(obj1, obj2)['provisioners']
        expect(new_provisioners[0]['run_list']).to eql(obj2['provisioners'][0]['_a_run_list'])
      end
      it 'all array name in new and old array must be normalized and value must be appended' do
        obj1 = {}
        obj2 = {
          'provisioners' => [{
            '_id' => '0',
            '_a_run_list' => %w[vagrant vim teracy]
          }]
        }
        new_provisioners = TeracyDev::Util.override(obj1, obj2)['provisioners']
        expect(new_provisioners[0]['run_list']).to eql(obj2['provisioners'][0]['_a_run_list'])
      end

      it 'all array name in new and old array must be normalized and value must be appended' do
        obj1 = {
          'provisioners' => [{
            '_id' => '0',
            '_a_run_list' => %w[vagrant vim helloworld]
          }]
        }
        obj2 = {
          'provisioners' => [{
            '_id' => '0',
            '_a_run_list' => %w[vagrant vim teracy]
          }]
        }
        new_provisioners = TeracyDev::Util.override(obj1, obj2)['provisioners']
        run_list = %w[vagrant vim helloworld vagrant vim teracy]
        expect(new_provisioners[0]['run_list']).to eql(run_list)
      end
    end

    context 'given two objects then unique override it with another object contain array' do
      it 'all array name in new and old array must be normalized and valued must be merged' do
        obj1 = {
          'provisioners' => [{
            '_id' => '0',
            '_ua_run_list' => %w[vim teracy widget testsuite]
          }]
        }

        obj2 = {
          'provisioners' => [{
            '_id' => '0',
            '_ua_run_list' => %w[vagrant vim teracy]
          }]
        }

        new_provisioners = TeracyDev::Util.override(obj1, obj2)['provisioners']
        expect(new_provisioners[0]['run_list']).to eql(%w[vim teracy widget testsuite vagrant])
      end

      it 'all array name in new and old array must be normalized and value must be merged' do
        obj1 = {
          'provisioners' => [{
            '_id' => '0',
            'run_list' => %w[vim teracy widget testsuite]
          }]
        }

        obj2 = {
          'provisioners' => [{
            '_id' => '0',
            '_ua_run_list' => %w[vagrant vim teracy]
          }]
        }

        new_provisioners = TeracyDev::Util.override(obj1, obj2)['provisioners']
        expect(new_provisioners[0]['run_list']).to eql(%w[vim teracy widget testsuite vagrant])
      end
      it 'all array name in new and old array must be normalize' do
        obj1 = {}
        obj2 = {
          'provisioners' => [{
            '_id' => '0',
            '_a_run_list' => %w[hi there]
          }]
        }
        new_provisioners = TeracyDev::Util.override(obj1, obj2)['provisioners']

        expect(new_provisioners[0]['run_list']).to eql(obj2['provisioners'][0]['_a_run_list'])
      end
    end

    context 'Giving many config file follow project base config requirement' do
      it 'after override the config must satisfy the requirement' do
        default_file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/config.json'
        teracy_default_config = JSON.parse(File.read(default_file))

        override_file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/config_override.json'
        teracy_override_config = JSON.parse(File.read(override_file))

        org_conf_file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/org_project.json'
        project_org_config = JSON.parse(File.read(org_conf_file))

        project1_conf_file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/project1.json'
        project1_config = JSON.parse(File.read(project1_conf_file))

        project2_conf_file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/project2.json'
        project2_config = JSON.parse(File.read(project2_conf_file))

        origin_conf_file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/config.json'
        origin_teracy_default_config = JSON.parse(File.read(origin_conf_file))

        origin_project1_file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/project1.json'
        origin_project1_config = JSON.parse(File.read(origin_project1_file))

        origin_project2_file = File.dirname(__FILE__) + '/fixtures/teracy-dev/util/project2.json'
        origin_project2_config = JSON.parse(File.read(origin_project2_file))

        final_config = TeracyDev::Util.override(teracy_default_config, teracy_override_config)
        final_config = TeracyDev::Util.override(final_config, project_org_config)
        final_config = TeracyDev::Util.override(final_config, project1_config)
        final_config = TeracyDev::Util.override(final_config, project2_config)

        final_synced_folders_len = final_config['vm']['synced_folders'].length
        origin_default_config_len = origin_teracy_default_config['vm']['synced_folders'].length
        origin_project1_config_len = origin_project1_config['vm']['synced_folders'].length
        origin_project2_config_len = origin_project2_config['vm']['synced_folders'].length
        expect(final_synced_folders_len).to eql(origin_default_config_len - 2 +
          origin_project1_config_len + origin_project2_config_len)

        guest = origin_project2_config['vm']['synced_folders'][2]['guest']
        host = origin_project2_config['vm']['synced_folders'][2]['host']
        id = origin_project2_config['vm']['synced_folders'][2]['id']
        expect(final_config['vm']['synced_folders'][6]['guest']).to eql(guest)
        expect(final_config['vm']['synced_folders'][6]['host']).to eql(host)
        expect(final_config['vm']['synced_folders'][6]['id']).to eql(id)

        expect(final_config['vm']['synced_folders'][6]['guest']).to eql(guest)
        expect(final_config['vm']['synced_folders'][6]['host']).to eql(host)
        expect(final_config['vm']['synced_folders'][6]['id']).to eql(id)

        final_aliases_len = final_config['plugins'][2]['options']['aliases'].length
        project1_aliases_len = origin_project1_config['plugins'][0]['options']['_ua_aliases'].length
        project2_aliases_len = origin_project2_config['plugins'][0]['options']['_ua_aliases'].length
        expect(final_aliases_len).to eql(project1_aliases_len + project2_aliases_len)
      end
    end
  end
end
