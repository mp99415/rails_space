Rails.application.routes.draw do
  get 'user/index'

  get 'user/register'

  post 'user/register'

  get 'site/index'

  get 'site/about'

  get 'site/help'

  get 'user/login'

  post 'user/login'

  get 'user/logout'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
