Qrcode::Application.routes.draw do
 resources :addresses, only: [:private, :public]
 resources :sessions, only: [:new, :create]

 root to: "sessions#new"
 
  match "/private",  	to: 'addresses#private',         	via: :get
  match "/public",   	to: 'addresses#public',          	via: :get
  
end
