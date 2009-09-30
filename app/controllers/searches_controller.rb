class SearchesController < ApplicationController

  def new
    @gems = @search.paginate(:page => params[:page])
  end

end
