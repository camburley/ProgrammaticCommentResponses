Rails.application.routes.draw do
  root 'home#index'

  # Admin
  scope 'admin' do
  	get '/' => 'admin#index', as: 'admin'

  	# Settings
  	scope 'settings' do
			match '/' => 'setting#index', as: 'admin_settings', via: [:get, :put]
		end
  end

  # Authentication
  match 'auth/:provider/callback', to: 'sessions#create', as: 'login', via: [:get, :post]
	match 'auth/failure', to: redirect('/'), via: [:get, :post]
	match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

	# Webhook
  match '/webhook' => 'messenger#callback', :via => :post
  get '/webhook' => 'messenger#verify_callback'
end