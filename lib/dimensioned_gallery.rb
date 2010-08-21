module ActiveRecord
  module Acts
    module DimensionedGallery
      def self.included(base)
        base.send :extend, ClassMethods
      end

      module ClassMethods

        def acts_as_dimensioned_gallery(options = {})

          cattr_accessor :automatic_polymorphic_paths
          self.automatic_polymorphic_paths = (options[:automatic_polymorphic_paths] || :true)

          holder = self.name.to_s.constantize
          holder.class_eval do
            has_many :galleries, :as => :holder
          end
          send :include, InstanceMethods
        end
        
      end

      module InstanceMethods
        def find_ancestry
          ths = self
          holders = Array.new
          holders << ths
          
          begin
            attributes = ths.attribute_names

            nxt = nil
            attributes.each do |attribute|
              if /_id$/.match(attribute)
                begin
                  klass = attribute.slice!(/_id$/).capitalize.constantize
                  nxt = klass.find(ths.send(attribute.to_sym))
                  holders << nxt
                  ths = nxt
                rescue NameError
                else
                  break
                end
              end
            end
          end while nxt

          return holders
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::Acts::DimensionedGallery