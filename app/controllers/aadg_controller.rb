class AadgController < ActionController::Base
#  include ActionController::UrlWriter

  before_filter :find_holder

  def find_gallery
    if params[:gallery_id]
      @gallery = Gallery.find(params[:gallery_id])
    end
  end

  def find_holder
    strs = request.path.split('/')
    if strs.index('galleries') != 1 && strs.index('galleries')
      holder_id = strs[strs.index('galleries') - 1].to_i
      holder_type = strs[strs.index('galleries') - 2]
      @klass = holder_type.capitalize.singularize.constantize
      @holder = @klass.find(holder_id)
    end
  end
end
