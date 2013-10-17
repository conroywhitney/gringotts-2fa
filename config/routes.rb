Rails.application.routes.draw do
  get "/authentication/info" => "gringotts/authentication#info" , :as => :authentication_info_page
end