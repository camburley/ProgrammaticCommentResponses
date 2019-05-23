class AdminController < ApplicationController
	before_action :authenticate, :page_selected
	layout 'admin'

  def index
  	
  end
end
