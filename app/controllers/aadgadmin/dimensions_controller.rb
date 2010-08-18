class Aadgadmin::DimensionsController < Aadgadmin::AadgController
  layout 'application'
  
  before_filter :find_gallery
  
  def index
    if params[:gallery_id]
      gallery = Gallery.find(params[:gallery_id])
      @dimensions = gallery.dimensions
    else
      @dimensions = Dimension.all
    end
  end

  def show
    @dimension = Dimension.find(params[:id])
  end
  
  def new
    if @gallery
      @dimensions = Dimension.all
      @dimension = @gallery.dimensions.build
    else
      @dimension = Dimension.new
    end
  end

  
  def create
    if @gallery
      if params[:dimension][:id]
        @dimension = Dimension.find(params[:dimension][:id])
        gdjoin = Gdjoin.find(:all, :conditions => "gallery_id = #{@gallery.id} AND dimension_id = #{@dimension.id}")

        respond_to do |format|
          if gdjoin.length == 0
            @gallery.dimensions << @dimension
            flash[:notice] = "Dimension added."
          else
            flash[:notice] = "Dimension already added to this gallery."
          end

          format.html { redirect_to url_for([@holder, @gallery])}
        end
      else
        @dimension = @gallery.dimensions.build(params[:dimension])

        respond_to do |format|
          if @dimension.save
            @gallery.dimensions << @dimension
            flash[:notice] = "Dimension successfully created."
            format.html { redirect_to url_for([@holder, @gallery]) }
          else
            @dimensions = Dimension.all
            format.html { render :action => 'new' }
          end
        end
      end
    else
      @dimension = Dimension.create(params[:dimension])

      respond_to do |format|
        if @dimension.save
          flash[:notice] = "Dimension successfully created."
          format.html { redirect_to dimensions_path }
        else
          format.html { render :action => 'new'}
        end
      end
    end
  end


  def edit
    @dimension = Dimension.find(params[:id])
  end


  def update
    @dimension = Dimension.find(params[:id])

    respond_to do |format|
      if @dimension.update_attributes(params[:dimension])
        flash[:notice] = "Dimension successfully updated."
        if @gallery
          format.html { redirect_to url_for([@holder, @gallery]) }
        else
          format.html { redirect_to dimensions_path }
        end
      else
        format.html { render :action => 'edit' }
      end
    end
  end

  
  def destroy
    dimension = Dimension.find(params[:id])

    if @gallery
      gdjoin = Gdjoin.find(:all, :conditions => "gallery_id = #{@gallery.id} AND dimension_id = #{dimension.id}")
      if gdjoin.length > 0
        gdjoin.first.destroy
      end

    else
      gdjoins = Gdjoin.find(:all, :conditions => "dimension_id = #{dimension.id}")
      gdjoins.each do |gd|
        gd.destroy
      end

      dimension.destroy
    end
    
    respond_to do |format|
      if @gallery
        format.html { redirect_to url_for([@holder, @gallery]) }
      else
        format.html { redirect_to dimensions_path }
      end
    end
  end
end