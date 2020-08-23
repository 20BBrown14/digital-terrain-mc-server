# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'web#show'
  get '/serverRules', to: 'web#get_server_rules'
  get '/serverInformation', to: 'web#get_server_information'
  get '/aboutUsInformation', to: 'web#get_about_us_information'
  get '/veteransInformation', to: 'web#get_veterans_information'
  post '/save', to: 'web#save'
  post '/applicationsubmit', to: 'web#submit_application'
  get '/loadApps', to: 'web#load_apps'
  post '/updateappstatus', to: 'web#update_app_status'
  post '/deleteapp', to: 'web#delete_app'
  get '/galleryImages', to: 'web#get_images'
  post '/deleteImage', to: 'web#delete_image'
  post '/toggleFeaturedImage', to: 'web#toggle_featured_image'
  post '/imageUpload', to: 'web#upload_image'
  get 'loggedin', to: 'web#logged_in'
end
