Coldcoin::Application.routes.draw do

 	resources :freezers, only: [:new, :create, :show]
 	resources :ovens, only: [:new, :create, :show, :addresses]
 
 	root to: "static#home"
 
  match "/freeze",  	to: 'freezers#new',   				via: :get
  match "/cold_view", to: 'freezers#show',  				via: :get
  match "/heatup",  	to: 'ovens#new',   						via: :get
  match "/hot_view",  to: 'ovens#show',						  via: :get
  match "/addresses",	to: 'ovens#addresses',				via: :get

  match "/help",    	to: 'static#help',    				via: :get
  match "/about",   	to: 'static#about',	  				via: :get
end
