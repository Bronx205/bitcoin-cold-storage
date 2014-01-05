Qrcode::Application.routes.draw do
 resources :addresses, only: [:new, :create, :private, :public]
 
 root to: "addresses#new"
 
  match "/private",  	to: 'addresses#private',         	via: :get
  match "/public",   	to: 'addresses#public',          	via: :get
  
end
