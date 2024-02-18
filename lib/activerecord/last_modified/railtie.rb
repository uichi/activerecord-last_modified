# frozen_string_literal: true

require 'rails/railtie'

module ActiveRecord
  module LastModified
    class Railtie < ::Rails::Railtie
      initializer "activerecord_last_mofified" do
        ActiveSupport.on_load(:active_record) do
          ActiveRecord::Base.include ActiveRecord::LastModified
        end
      end
    end
  end
end
