Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #root to: 'formulario#index'
  get '/formulario', to: 'formulario#index'
end
