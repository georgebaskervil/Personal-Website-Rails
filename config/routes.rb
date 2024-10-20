Rails.application.routes.draw do
  
  match '/posts(/*all)', to: redirect { |params, request|
    "https://blog.geor.me/#{params[:all]}"
  }, via: :all 

  match '/pictures(/*all)', to: redirect { |params, request|
    "https://pixlfed.geor.me/#{params[:all]}"
  }, via: :all

  get "/waveform", to: "waveform#index"
  get "/privacy", to: "privacy#index"
  get "/licensing", to: "licensing#index"
  get "/extras", to: "extras#index"
  get "/credits", to: "credits#index"
  get "/contact", to: "contact#index"
  get "/analytics", to: "analytics#index"
  get "/dmca", to: "dmca#index"
  get "/eightyeightbythirtyone", to: "eightyeightbythirtyone#index"
  root "homepage#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
