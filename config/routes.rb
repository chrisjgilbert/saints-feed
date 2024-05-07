Rails.application.routes.draw do
  root "articles#index"

  mount MissionControl::Jobs::Engine, at: "/jobs"
end
