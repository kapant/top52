require "rails/generators"
module Sessions
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option "user-class", type: :string

      source_root File.expand_path("../install/templates", __FILE__)

      def determine_user_class
        @user_class = options["user-class"].presence ||
                      ask("What is your user class called? [User]").presence ||
                      "::User"
      end

      def install_migrations
        puts "Copying over Sessions migrations..."
        Dir.chdir(Rails.root) do
          `rake sessions:install:migrations`
        end
      end

      def add_projects_initializer
        path = "#{Rails.root}/config/initializers/sessions.rb"
        if File.exists?(path)
          puts "Skipping config/initializers/sessions.rb creation, as file already exists!"
        else
          puts "Adding core initializer (config/initializers/sessions.rb)..."
          template "initializer.rb", path
          require path
        end
      end

      def run_migrations
        puts "Running rake db:migrate"
        `rake db:migrate`
      end

      def mount_engine
        puts "Mounting Sessions::Engine at \"/sessions\" in config/routes.rb..."
        insert_into_file("#{Rails.root}/config/routes.rb", after: /routes.draw.do\n/) do
          %Q(
  # This line mounts Sessions's routes at /sessions by default.
  mount Sessions::Engine, :at => "/sessions"
)
        end
      end

      def finished
        output = "\n\n" + ("*" * 53)
        output += "\nDone! Sessions engine has been successfully installed."

        puts output
      end

      private

      def user_class
        @user_class
      end
    end
  end
end
