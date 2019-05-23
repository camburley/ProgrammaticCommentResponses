class SettingController < ApplicationController
	before_action :authenticate
	layout 'admin'

	require 'net/http'
	require 'uri'
	require 'json'

  def index
		unless current_user.pages.any?
			Page.add_pages(current_user.id)
		end

		if request.put?
			# PAGE SELECTION
			if params[:page_id] && params[:select_page] == "true" && Page.find_by_id(params[:page_id])
				current_user.update_attributes(page_selected: params[:page_id])
				current_page.update_attributes(echo: true)
				
				redirect_to admin_settings_path
			elsif params[:disconnect_page] == "true"
				current_page.update_attributes(echo: false)
				current_user.update_attributes(page_selected: nil)
				
				redirect_to admin_settings_path
			end
			
			# ECHO
			if params[:echo] && current_page
				status = current_page.echo.nil? || current_page.echo == false ? true : false
				current_page.update_attributes(echo: status)
			end
		end
  end
end
