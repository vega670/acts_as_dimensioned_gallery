module ActionView
  module Helpers
    module UrlHelper

      # Gallery Images
      def gallery_images_path(gallery)
        return url_for(holder(gallery)|[gallery, :images])
      end

      def aadgadmin_gallery_images_path(gallery)
        return url_for(holder(gallery)|[:aadgadmin, gallery]) + '/images'
      end

      def new_aadgadmin_gallery_image_path(gallery)
        return url_for(holder(gallery)|[:aadgadmin, gallery]) + '/images/new'
      end

      def gallery_image_path(gallery, image)
        return url_for(holder(gallery)|[gallery, image])
      end

      def aadgadmin_gallery_image_path(gallery, image)
        return url_for(holder(gallery)|[:aadgadmin, gallery]) + '/images/' + image.id.to_s
      end


      # Gallery Dimensions
      def aadgadmin_gallery_dimensions_path(gallery)
        return url_for(holder(gallery)|[:aadgadmin, gallery]) + '/dimensions'
      end

      def new_aadgadmin_gallery_dimension_path(gallery)
        return url_for(holder(gallery)|[:aadgadmin, gallery]) + '/dimensions/new'
      end

      def edit_aadgadmin_gallery_dimension_path(gallery, dimension)
        return url_for(holder(gallery)|[:aadgadmin, gallery]) + '/dimensions/' + dimension.id.to_s + '/edit'
      end

      def aadgadmin_gallery_dimension_path(gallery, dimension)
        return url_for(holder(gallery)|[:aadgadmin, gallery]) + '/dimensions/' + dimension.id.to_s
      end


      # Galleries
      def galleries_path()
        if @holder_url
          return url_for([@holder_url]) + '/galleries'
        else
          return ''
        end
      end

      def aadgadmin_galleries_path()
        if @holder_url
          return url_for([@holder_url]) + '/aadgadmin/galleries'
        else
          return ''
        end
      end

      def gallery_path(gallery)
        return url_for(holder(gallery)) + '/galleries/' + gallery.id.to_s
      end

      def aadgadmin_gallery_path(gallery)
        return url_for(holder(gallery)) + '/aadgadmin/galleries/' + gallery.id.to_s
      end

      def new_aadgadmin_gallery_path()
        if @holder_url
          return url_for([@holder_url]) + '/aadgadmin/galleries/new'
        else
          return ''
        end
      end

      def edit_aadgadmin_gallery_path(gallery)
        return url_for(holder(gallery)) + '/aadgadmin/galleries/' + gallery.id.to_s + '/edit'
      end

      def holder_path
        if @holder_url
          return url_for([@holder_url])
        else
          return url_for(holder())
        end
      end

      private
        def holder(gallery = nil)
          if !gallery
            if @gallery
              gallery = @gallery
            else
              return nil
            end
          end
          klass = gallery.holder_type.singularize.capitalize.constantize
          holder = klass.find(gallery.holder_id)
          return holder.find_ancestry
        end
    end
  end
end