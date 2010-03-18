require 'helper'
require 'rack/test'
require 'json'

set :environment, :test

path '/:name' do
  %w(get put post delete head).each do |method_name|
    instance_eval %Q{
      #{method_name.to_s} do
        [#{method_name.inspect}, params].to_json
      end
    }
  end
end

class TestSinatraPath < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def self.should_response(method_name, path, params)
    context "#{method_name} '#{path}'" do
      should "response #{method_name} #{path}" do
        instance_eval %Q{
          #{method_name} %q{#{path}}
          assert last_response.ok?
          method, params = JSON.parse(last_response.body)
          assert_equal %q{#{method_name}}, method
          assert_equal %q{#{params.to_json}}, params.to_json
        }
      end
    end
  end

  def self.should_head_response(path)
    context "head '#{path}'" do
      should "response head #{path}" do
        instance_eval %Q{
          head %q{#{path}}
          assert last_response.ok?
        }
      end
    end
  end

  %w(get put post delete).each do |method_name|
    should_response method_name, '/foobar', {'name' => 'foobar'}
  end

  should_head_response '/foobar'
end
