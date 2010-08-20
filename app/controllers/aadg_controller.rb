class AadgController < ActionController::Base

  layout 'aadg'

  before_filter :find_holders_url

  def find_gallery
    if params[:gallery_id]
      @gallery = Gallery.find(params[:gallery_id])
    end
  end

#  def find_holder
#    strs = request.path.split('/')
#    if strs.index('galleries') && (strs.index('galleries') != 1) && strs.index('aadgadmin') != 1 && !('dimensions' == strs[1])
#      if strs.include? 'aadgadmin'
#        offset = 2
#      else
#        offset = 1
#      end
#      holder_id = strs[strs.index('galleries') - offset].to_i
#      holder_type = strs[strs.index('galleries') - offset - 1]
#      klass = holder_type.capitalize.singularize.constantize
#      @holder = klass.find(holder_id)
#    end
#  end

  def find_holders_url
    strs = request.path.split('/')
    if (strs.include? 'aadgadmin') || (strs.include? 'galleries')
      if strs.include? 'aadgadmin'
        index = strs.index('aadgadmin') - 1
      else
        index = strs.index('galleries') - 1
      end

      @holders_url = Array.new

      index.downto(0) do |i|
        sym = (strs[i].singularize + "_id").to_sym
        if params[sym]
          klass = strs[i].singularize.capitalize.constantize
          @holders_url << klass.find(params[sym])
        end
        @holder_url = @holders_url.first
      end

      
    end
  end
end
