module ActiveRecord
  module Acts
    module DimensionedGallery
      def self.included(base)
        base.send :extend, ClassMethods
      end

      module ClassMethods

        def acts_as_dimensioned_gallery(options = {})
          
          holder = self.name.to_s.constantize
          holder.class_eval do
            has_many :galleries, :as => :holder
          end
          send :include, InstanceMethods
        end
      end

      module InstanceMethods

      end
    end
  end
end

ActiveRecord::Base.send :include, ActiveRecord::Acts::DimensionedGallery