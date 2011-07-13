class Aadgadmin::AadgController < AadgController
  layout 'aadg'
  before_filter :protect_aadgadmin

  def find_dimension
    if params[:dimension_id]
      @dimension = Dimension.find(params[:dimension_id])
    end
  end
  
  private
    def protect_aadgadmin
      if defined? AADG_AUTHENTICATE
        send AADG_AUTHENTICATE
      end
    end
  
end
