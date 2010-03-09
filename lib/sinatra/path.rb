require 'sinatra/base'

module Sinatra
  module Path
    class Base
      def initialize(*args)
        @args = args
      end

      [
        :get, :put, :post, :delete, :head, :template, :layout, :before,
        :error, :not_found, :configures, :configure, :set, :set_option,
        :set_options, :enable, :disable, :use, :development?, :test?,
        :production?, :use_in_file_templates!, :helpers, :mime_type
      ].each do |method_name|
        eval <<-RUBY, binding, '(__DELEGATE__)', 1
          def #{method_name}(*args, &b)
            ::Sinatra::Application.send(#{method_name.inspect}, *@args, &b)
          end
          private #{method_name.inspect}
        RUBY
      end
    end

    def path(*args, &block)
      Base.new(*args).instance_eval(&block)
    end
  end

  register Path
end
