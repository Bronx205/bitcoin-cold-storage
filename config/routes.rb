Coldcoin::Application.routes.draw do

 	resources :addresses, only: [:new, :create, :show, :load, :show_loaded]
 
 	root to: "static#home"
 
  match "/freeze",  	to: 'addresses#new',   				via: :get
  match "/cold_view", to: 'addresses#show',  				via: :get
  match "/heatup",  	to: 'addresses#load',   			via: :get
  match "/hot_view",  to: 'addresses#show_loaded',  via: :get

  match "/help",    	to: 'static#help',    				via: :get
  match "/about",   	to: 'static#about',	  				via: :get
end
