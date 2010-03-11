require 'sinatra/base'

module Sinatra
  module Path
    class Base
      def initialize(path, opts={})
        @path, @opts = path, opts
      end

      [:get, :put, :post, :delete, :head].each do |method_name|
        eval <<-RUBY, binding
          def #{method_name}(opts={}, &b)
            ::Sinatra::Application.send(
              #{method_name.inspect}, @path, @opts.merge(opts), &b
            )
          end
          private #{method_name.inspect}
        RUBY
      end
    end

    def path(path, opts={}, &block)
      Base.new(path, opts).instance_eval(&block)
    end
  end

  register Path
end
