class ObjectStatesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @report = Report.new
    @object_states = ObjectState.all
  end

  def search
    @report = Report.new
    if params[:object_id].blank?
      flash[:danger] = "Please provide valid object_id for search"
      return render "index"
    elsif params[:object_type].blank?
      flash[:danger] = "Please provide valid object_type for search" 
      return render "index"
    elsif params[:timestamp].blank? || @report.valid_timestamp?(params[:timestamp]) == false
      flash[:danger] = "Please provide valid unix timestamp for search" 
      return render "index"
    end

    @object_states = ObjectState.where(:object_id => params[:object_id], :object_type => params[:object_type], :timestamp.lte => DateTime.strptime(params[:timestamp],'%s')).order_by(:timestamp => "desc")
    render "index"
  end
end
