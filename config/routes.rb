Coldcoin::Application.routes.draw do

 	resources :freezers, only: [:new, :create, :show, :load, :show_loaded]
 
 	root to: "static#home"
 
  match "/freeze",  	to: 'freezers#new',   				via: :get
  match "/cold_view", to: 'freezers#show',  				via: :get
  match "/heatup",  	to: 'freezers#load',   			via: :get
  match "/hot_view",  to: 'freezers#show_loaded',  via: :get

  match "/help",    	to: 'static#help',    				via: :get
  match "/about",   	to: 'static#about',	  				via: :get
end
