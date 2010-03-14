module ActsAsDimensionedGallery

  module ClassMethods
    def acts_as_dimensioned_gallery
      include InstanceMethods
    end
  end
end