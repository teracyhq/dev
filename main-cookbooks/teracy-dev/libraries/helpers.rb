module TeracyDev
    module Helpers
        def db_empty?(host, username, pwd, db_name)
            ::Mysql.new(host, username, pwd).select_db(db_name).list_tables().empty?
        end

        def db_tbl_exists?(host, username, pwd, db_name, tbl)
            querySt = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '#{tbl}'"
            ::Mysql.new(host, username, pwd).select_db(db_name).query(querySt).num_rows > 0
        end


        def db_tbl_empty?(host, username, pwd, db_name, tbl)
            m = ::Mysql.new(host, username, pwd, db_name)
            m.select_db(db_name).query('SELECT COUNT(*) FROM ' + tbl).fetch_row()[0].to_i < 1
        end

        def db_column_exists?(host, username, pwd, db_name, tbl, colum)
            querySt = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '#{tbl}' and COLUMN_NAME = '#{colum}'"
            ::Mysql.new(host, username, pwd).select_db(db_name).query(querySt).num_rows > 0
        end

        # Determines if php is installed on a system.
        #
        # @return [Boolean]
        def php_installed?
          !which('php').nil?
        end

        # Determines if mysql is installed on a system.
        #
        # @return [Boolean]
        def mysql_installed?
          !which('mysql').nil?
        end

        # Determines if ruby is installed on a system.
        #
        # @return [Boolean]
        def ruby_installed?
          !which('ruby').nil?
        end

        # Determines if rbenv is installed on a system.
        #
        # @return [Boolean]
        def rbenv_installed?
          !which('rbenv').nil?
        end

        # Determines if ruby-build is installed on a system.
        #
        # @return [Boolean]
        def ruby_build_installed?
          !which('ruby-build').nil?
        end

        # Finds a command in $PATH
        #
        # @return [String, nil]
        def which(cmd)
          paths = (ENV['PATH'].split(::File::PATH_SEPARATOR) + %w(/bin /usr/bin /sbin /usr/sbin))

          paths.each do |path|
            possible = File.join(path, cmd)
            return possible if File.executable?(possible)
          end

          nil
        end
    end
end

Chef::Recipe.send(:include, ::TeracyDev::Helpers)
Chef::Resource.send(:include, ::TeracyDev::Helpers)
Chef::Provider.send(:include, ::TeracyDev::Helpers)
