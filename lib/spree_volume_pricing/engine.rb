module SpreeVolumePricing
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_volume_pricing'


    initializer 'spree_volume_pricing.environment', before: 'spree.environment' do |app|
      require File.join(File.dirname(__FILE__), '../../app/models/spree_volume_pricing/configuration.rb')
    end

    initializer 'spree_volume_pricing.environment', before: :load_config_initializers do |_app|
      SpreeVolumePricing::Config = SpreeVolumePricing::Configuration.new
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      String.class_eval do
        def to_range
          case count('.')
          when 2
            elements = split('..')
            return Range.new(elements[0].delete('(').to_i, elements[1].to_i)
          when 3
            elements = split('...')
            return Range.new(elements[0].delete('(').to_i, elements[1].to_i - 1)
          else
            raise ArgumentError.new(
              I18n.t(
                :'activerecord.errors.messages.could_not_conver_to_range',
                number: self
              )
            )
          end
        end
      end
    end

    config.autoload_paths += %W(#{config.root}/lib)
    config.to_prepare(&method(:activate).to_proc)
  end
end
