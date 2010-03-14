class GalleriesController < ApplicationController
  layout 'application'
  
  before_filter :find_holder
  
  def index
    if @holder
      @galleries = @holder.galleries
    else
      @galleries = Gallery.all
    end
    
    respond_to do |format|
      format.html
    end
  end

  def show
    @gallery = Gallery.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  def new
    if @holder
      @gallery = @holder.galleries.new
    else
      @gallery = Gallery.new
    end
    
    respond_to do |format|
      format.html
    end
  end

  def edit
    @gallery = Gallery.find(params[:id])
    
    respond_to do |format|
      format.html
    end
  end

  def create
    if @holder
      @holder.galleries.create(params[:gallery])
      
      respond_to do |format|
        format.html { redirect_to :controller => @holder.class.to_s.pluralize.downcase, :action => :show, :id => @holder.id }
      end
    else
      @gallery = Gallery.create(params[:gallery])
      
      respond_to do |format|
        format.html { redirect_to galleries_path }
      end
    end
  end

  def update
    
  end

  def destroy
    
  end
  
  def js_set_gallery_image
    gallery = Gallery.find(params[:gallery_id])
    gallery.gallery_image_id = params[:image_id]
    gallery.save
    
    render :text => 'Image set as gallery image.'
  end
  
  private
    def find_holder
      strs = request.path.split('/')
      if strs.index('galleries') == 1
        @holder = nil
      else
        holder_id = strs[strs.index('galleries') - 1].to_i
        holder_type = strs[strs.index('galleries') - 2]
        @klass = holder_type.capitalize.singularize.constantize
        @holder = @klass.find(holder_id)
      end
    end
end
