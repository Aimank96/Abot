Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  root to: "web/static_pages#home"

  post 'slack', to: "slack/static#missing_content", constraints: MissingContent
  post 'slack', to: "slack/static#help", constraints: DisplayHelp
  post 'slack', to: "slack/feedbacks#create"

  get 'oauth/callback', to: "web/sessions#create"

  namespace :web do
    resource :session, only: [:destroy]
    resources :subscriptions, only: [:new, :create] do
      get :confirm, on: :collection
    end
  end

  get '/robots.txt' => RobotsTxt
end
