class Aadgadmin::AadgController < AadgController
  layout 'aadg'

  def find_dimension
    if params[:dimension_id]
      @dimension = Dimension.find(params[:dimension_id])
    end
  end
end
