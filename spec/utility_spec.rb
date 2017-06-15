require 'json'
require "./lib/utility"

describe "utility" do
  describe "overrides" do
    context "given an empty obj2" do
      it "returns the same obj1" do
        obj1 = {
          "msg" => "hello"
        }
        new_obj = overrides(obj1, {})
        expect(new_obj).to eql(obj1)
      end
    end

    context "given a simple obj2" do
      it "returns the new obj" do
        obj1 = {
          "msg"=> "hello"
        }
        new_obj = overrides(obj1, {"a"=> "b"})
        expect(new_obj).to eql({
          "msg"=> "hello",
          "a"=> "b"
        })
      end
    end

    context "given a simple override obj2" do
      it "returns the new overriden obj" do
        obj1 = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config.json'))
        obj2 = {
          "vm" => {
            "box_version" => "1.2.3"
          },
          "vb" => {
            "memory" => 2048
          }
        }
        new_obj = overrides(obj1, obj2)
        # puts new_obj
        expect(new_obj['vm']['box_version']).to eql('1.2.3')
        expect(new_obj['vb']['memory']).to eql(2048)
      end
    end

    context "given a simple obj2 to append by default index" do
      it "returns the new overriden obj" do
        obj1 = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config.json'))
        obj2 = {
          "plugins" => [{
            "_id" => "2",
            "name" => "my-plugin",
            "required" => true
          }]
        }
        new_plugins = overrides(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(3)
        expect(new_plugins[2]).to eql(obj2['plugins'][0])
      end
    end

    context "given a simple obj2 to append by specified index" do
      it "returns the new overriden obj" do
        obj1 = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config.json'))
        obj2 = {
          "plugins" => [{
            "_id" => "2",
            "_idx" => 0,
            "name" => "my-plugin",
            "required" => true
          }]
        }
        new_plugins = overrides(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(3)
        expect(new_plugins[0]).to eql(obj2['plugins'][0])
      end
    end

    context "given a deep level obj2 to append by default index" do
      it "returns the new overriden obj" do
        obj1 = {
          "provisioners" => [{
            "_id" => "0",
            "type" => "chef_solo",
            "json" => {
              "teracy-dev" => {
                "directories" => [{
                  "_id" => "0",
                  "path" => "/home/vagrant/workspace",
                  "owner" => "vagrant",
                  "group" => "vagrant",
                  "mode" => "0775",
                  "action" => "create"
                }, {
                  "_id" => "1",
                  "path" => "/home/vagrant/test",
                  "owner" => "vagrant",
                  "group" => "vagrant",
                  "mode" => "0775",
                  "action" => "create"
                }]
              }
            }
          }]
        }
        obj2 = {
          "provisioners" => [{
            "_id" => "0",
            "json" => {
              "teracy-dev" => {
                "directories" => [{
                  "_id": "2",
                  "path" => "/home/vagrant/test2"
                }]
              }
            }
          }]
        }
        new_obj = overrides(obj1, obj2)
        new_directories = new_obj['provisioners'][0]['json']['teracy-dev']['directories']
        expect(new_directories.length).to eql(3)
        expect(new_directories[2]).to eql(obj2['provisioners'][0]['json']['teracy-dev']['directories'][0])
      end
    end

    context "given a deep level obj2 to append by specified index" do
      it "returns the new overriden obj" do
        obj1 = {
          "provisioners" => [{
            "_id" => "0",
            "type" => "chef_solo",
            "json" => {
              "teracy-dev" => {
                "directories" => [{
                  "_id" => "0",
                  "path" => "/home/vagrant/workspace",
                  "owner" => "vagrant",
                  "group" => "vagrant",
                  "mode" => "0775",
                  "action" => "create"
                }, {
                  "_id" => "1",
                  "path" => "/home/vagrant/test",
                  "owner" => "vagrant",
                  "group" => "vagrant",
                  "mode" => "0775",
                  "action" => "create"
                }]
              }
            }
          }]
        }
        obj2 = {
          "provisioners" => [{
            "_id" => "0",
            "json" => {
              "teracy-dev" => {
                "directories" => [{
                  "_id": "2",
                  "_idx" => 1,
                  "path" => "/home/vagrant/test2"
                }]
              }
            }
          }]
        }
        new_obj = overrides(obj1, obj2)
        new_directories = new_obj['provisioners'][0]['json']['teracy-dev']['directories']
        expect(new_directories.length).to eql(3)
        expect(new_directories[1]).to eql(obj2['provisioners'][0]['json']['teracy-dev']['directories'][0])
      end
    end

    context "given a simple obj2 to override by default" do
      it "returns the new overriden obj" do
        obj1 = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config.json'))
        obj2 = {
          "plugins" => [{
            "_id" => "0",
            "rsync_on_startup" => false
          }]
        }
        new_plugins = overrides(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(2)
        expect(new_plugins[0]['rsync_on_startup']).to eql(false)
      end
    end

    context "given a simple obj2 to override by _op='o'" do
      it "returns the new overriden obj" do
        obj1 = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config.json'))
        obj2 = {
          "plugins" => [{
            "_id" => "0",
            "_op" => 'o',
            "rsync_on_startup" => false
          }]
        }
        new_plugins = overrides(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(2)
        expect(new_plugins[0]['rsync_on_startup']).to eql(false)
      end
    end

    context "given a simple obj2 to override by _op='r'" do
      it "returns the new overriden obj" do
        obj1 = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config.json'))
        obj2 = {
          "plugins" => [{
            "_id" => "0",
            "_op" => 'r',
            "rsync_on_startup" => false
          }]
        }
        new_plugins = overrides(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(2)
        expect(new_plugins[0]).to eql(obj2['plugins'][0])
      end
    end

    context "given a simple obj2 to override by _op='d'" do
      it "returns the new overriden obj" do
        obj1 = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config.json'))
        obj2 = {
          "plugins" => [{
            "_id" => "0",
            "_op" => 'd'
          }]
        }
        new_plugins = overrides(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(1)
        expect(new_plugins[0]).to eql({
          "_id" => "1",
          "name" => "vagrant-rsync-back",
          "required" => true
        })
      end
    end

    context "given a simple obj2 to replace existing array" do
      it "returns the new overriden obj" do
        obj1 = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config.json'))
        obj2 = {
          "_r_plugins" => [{
            "_id" => "0",
            "name" => "my-plugin",
            "required" => true
          }]
        }
        new_plugins = overrides(obj1, obj2)['plugins']
        expect(new_plugins.length).to eql(1)
        expect(new_plugins).to eql(obj2['_r_plugins'])
      end
    end

    context "given a simple obj2 to replace existing text array" do
      it "returns the new overriden obj" do
        obj1 = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config.json'))
        obj2 = {
          "provisioners" => [{
            "_id" => "0",
            "run_list" => [
              "my",
              "new",
              "run-list"
            ]
          }]
        }
        new_provisioners = overrides(obj1, obj2)['provisioners']
        # puts new_provisioners
        expect(new_provisioners[0]['run_list']).to eql(obj2['provisioners'][0]['run_list'])
      end
    end

    context "given a simple obj2 to replace existing text array with an empty array" do
      it "returns the new overriden obj" do
        obj1 = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config.json'))
        obj2 = {
          "provisioners" => [{
            "_id" => "0",
            "run_list" => []
          }]
        }
        new_provisioners = overrides(obj1, obj2)['provisioners']
        # puts new_provisioners
        expect(new_provisioners[0]['run_list']).to eql(obj2['provisioners'][0]['run_list'])
      end
    end
    context "given an object then override it with another object containing an array" do
      it "all array name in new and old array must be normalized" do
        obj1 = {}
        obj2 = {
          "provisioners" => [{
            "_id" => "0",
            "_a_run_list" => []
          }]
        }
        new_provisioners = overrides(obj1, obj2)['provisioners']
        expect(new_provisioners[0]['run_list']).to eql(obj2['provisioners'][0]['_a_run_list'])
      end
      it "all array name in new and old array must be normalized and value must be appended" do
        obj1 = {}
        obj2 = {
          "provisioners" => [{
            "_id" => "0",
            "_a_run_list" => ["vagrant", "vim", "teracy"]
          }]
        }
        new_provisioners = overrides(obj1, obj2)['provisioners']
        expect(new_provisioners[0]['run_list']).to eql(obj2['provisioners'][0]['_a_run_list'])
      end
      it "all array name in new and old array must be normalized and value must be appended" do
        obj1 = {
          "provisioners" => [{
            "_id" => "0",
            "_a_run_list" => ["vagrant", "vim", "helloworld"]
          }]
        }
        obj2 = {
          "provisioners" => [{
            "_id" => "0",
            "_a_run_list" => ["vagrant", "vim", "teracy"]
          }]
        }
        new_provisioners = overrides(obj1, obj2)['provisioners']
        expect(new_provisioners[0]['run_list']).to eql(["vagrant", "vim", "helloworld", "vagrant", "vim", "teracy"])
      end
    end

    context "given two objects then unique override it with another object contain array" do
      it "all array name in new and old array must be normalized and valued must be merged" do
        obj1 = {
          "provisioners" => [{
            "_id" => "0",
            "_ua_run_list" => ["vim", "teracy", "widget", "testsuite"]
          }]
        }

        obj2 = {
          "provisioners" => [{
            "_id" => "0",
            "_ua_run_list" => ["vagrant", "vim", "teracy"]
          }]
        }
        obj1_origin = obj1.clone

        new_provisioners = overrides(obj1, obj2)['provisioners']
        expect(new_provisioners[0]['run_list']).to eql(["vim", "teracy", "widget", "testsuite", "vagrant"])
      end
      it "all array name in new and old array must be normalized and value must be merged" do
        obj1 = {
          "provisioners" => [{
            "_id" => "0",
            "run_list" => ["vim", "teracy", "widget", "testsuite"]
          }]
        }

        obj2 = {
          "provisioners" => [{
            "_id" => "0",
            "_ua_run_list" => ["vagrant", "vim", "teracy"]
          }]
        }
        obj1_origin = obj1.clone

        new_provisioners = overrides(obj1, obj2)['provisioners']
        expect(new_provisioners[0]['run_list']).to eql(["vim", "teracy", "widget", "testsuite", "vagrant"])
      end
      it "all array name in new and old array must be normalize" do
        obj1 = {}
        obj2 = {
          "provisioners" => [{
            "_id" => "0",
            "_a_run_list" => ["hi", "there"]
          }]
        }
        new_provisioners = overrides(obj1, obj2)['provisioners']

        expect(new_provisioners[0]['run_list']).to eql(obj2['provisioners'][0]['_a_run_list'])
      end
    end

    context "Giving many config file follow project base config requirement" do
      it "after override the config must satisfy the requirement" do
        teracy_default_config = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config.json'))
        teracy_override_config = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config_overide.json'))
        project_org_config = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/org_project.json'))
        project1_config = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/project1.json'))
        project2_config = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/project2.json'))

        origin_teracy_default_config = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config.json'))
        origin_teracy_override_config = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/config_overide.json'))
        origin_project_org_config = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/org_project.json'))
        origin_project1_config = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/project1.json'))
        origin_project2_config = JSON.parse(File.read(File.dirname(__FILE__) + '/fixture/project2.json'))

        final_config = overrides(teracy_default_config, teracy_override_config)
        final_config = overrides(final_config, project_org_config)
        final_config = overrides(final_config, project1_config)
        final_config = overrides(final_config, project2_config)

        expect(final_config['vm']['synced_folders'].length).to eql(origin_teracy_default_config['vm']['synced_folders'].length - 2 +
          origin_project1_config['vm']['synced_folders'].length +
          origin_project2_config['vm']['synced_folders'].length)

        expect(final_config['vm']['synced_folders'][6]['guest']).to eql(origin_project2_config['vm']['synced_folders'][2]['guest'])
        expect(final_config['vm']['synced_folders'][6]['host']).to eql(origin_project2_config['vm']['synced_folders'][2]['host'])
        expect(final_config['vm']['synced_folders'][6]['id']).to eql(origin_project2_config['vm']['synced_folders'][2]['id'])

        expect(final_config['vm']['synced_folders'][6]['guest']).to eql(origin_project2_config['vm']['synced_folders'][2]['guest'])
        expect(final_config['vm']['synced_folders'][6]['host']).to eql(origin_project2_config['vm']['synced_folders'][2]['host'])
        expect(final_config['vm']['synced_folders'][6]['id']).to eql(origin_project2_config['vm']['synced_folders'][2]['id'])

        expect(final_config['plugins'][2]['options']['aliases'].length).to eql(origin_project1_config['plugins'][0]['options']['_ua_aliases'].length +
          origin_project2_config['plugins'][0]['options']['_ua_aliases'].length)
      end
    end
  end
end
