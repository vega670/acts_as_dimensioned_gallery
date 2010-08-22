class AadgController < ActionController::Base

  layout 'aadg'

  before_filter :find_holders_url

  def find_gallery
    if params[:gallery_id]
      @gallery = Gallery.find(params[:gallery_id])
    end
  end


  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end

    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404.html", :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end


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
