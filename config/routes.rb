Coldcoin::Application.routes.draw do

 	resources :addresses, only: [:new, :create, :show]
 
 	root to: "static#home"
 
  match "/setup",  	to: 'addresses#new',   	via: :get
  match "/view",   	to: 'addresses#show',  	via: :get
  
  match "/help",    	to: 'static#help',    via: :get
  match "/about",   	to: 'static#about',	  via: :get
end
