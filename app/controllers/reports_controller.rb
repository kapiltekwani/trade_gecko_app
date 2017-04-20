class ReportsController < ApplicationController
  def create
    @report = Report.new(params[:report])
    if @report.save
      flash[:notice] = "CSV uploaded successfully"
    else
      flash[:danger] = @report.errors.full_messages.join(',')
    end
    
    redirect_to object_states_path
  end
end
