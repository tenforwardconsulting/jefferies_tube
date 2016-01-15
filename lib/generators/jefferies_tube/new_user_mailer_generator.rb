module JefferiesTube
  module Generators
    class NewUserMailerGenerator < Rails::Generators::Base
      desc "This generator creates a mailer to send your new users a link to reset their passwords"

      def copy_mailer
        copy_file 'new_user_mailer.rb', 'app/mailers/new_user_mailer.rb'
      end
    end
  end
end
