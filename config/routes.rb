Qrcode::Application.routes.draw do
 resources :addresses, only: [:private, :public]
 
  match "/private",  to: 'addresses#private',         via: :get
  match "/public",   to: 'addresses#public',          via: :get
  
end
