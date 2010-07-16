class DimensionsController < ApplicationController
  layout 'application'
  
  before_filter :find_gallery
  
  def index
    @dimensions = Dimension.all
    
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @dimensions = Dimension.all
    @dimension = @gallery.dimensions.build
    
    respond_to do |format|
      format.html
    end
  end
  
  def create
    if params[:dimension][:id]
      dimension = Dimension.find(params[:dimension][:id])
      @gallery.dimensions << dimension
      
      respond_to do |format|
        format.html { redirect_to gallery_path(@gallery) }
      end
    else
      @dimensions = Dimension.all
      dimension = @gallery.dimensions.build(params[:dimension])
      
      respond_to do |format|
        if dimension.save
          @gallery.dimensions << dimension
          flash[:notice] = 'Dimension successfully created.'
          format.html { redirect_to gallery_path(@gallery) }
        else
          format.html { render :action => "new" }
        end
      end
    end
    @gallery.add_dimension(dimension)
  end
  
  def destroy
    dimension = Dimension.find(params[:id])
    
    dimension.galleries.each do |gallery|
      gallery.destroy_dimension(dimension)
    end
    
    dimension.galleries.delete_all
    dimension.destroy
    
    respond_to do |format|
      if @gallery
        format.html { redirect_to(@gallery) }
      else
        format.html { redirect_to(dimensions_path) }
      end
    end
  end
  
  def remove
    dimension = Dimension.find(params[:dimension_id])
    
    if @gallery
      dimension.galleries.delete(@gallery)
      
      @gallery.remove_dimension(dimension)
    else
      galleries = dimension.galleries
      dimension.galleries.delete_all
      
      galleries.each do |gallery|
        gallery.remove_dimension(dimension)
      end
    end
    
    respond_to do |format|
      if @gallery
        format.html { redirect_to(@gallery) }
      else
        format.html { redirect_to(dimensions_path) }
      end
    end
  end
  
  private
    def find_gallery
      if params[:gallery_id]
        @gallery = Gallery.find(params[:gallery_id])
      end
    end

end