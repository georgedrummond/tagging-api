Rails.application.routes.draw do
  post   '/tag', to: 'tags#create'
  delete '/tags/:entity_type/:entity_identifier', to: 'tags#destroy'
  get    '/tags/:entity_type/:entity_identifier', to: 'tags#show'

  get    '/stats', to: 'stats#index'
  get    '/stats/:entity_type/:entity_identifier', to: 'stats#show'
end
