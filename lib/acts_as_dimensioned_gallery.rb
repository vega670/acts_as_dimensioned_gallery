require 'instance_methods'
require 'class_methods'

module ActsAsDimensionedGallery
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def acts_as_dimensioned_gallery
      include InstanceMethods
    end
  end
end