Rails.application.routes.draw do
  root "articles#index"

  resources :articles do 
    resources :comments 
  end 
end

# /articles GET (index), (new) -> POST (create) 
# /articles/1 GET (show), (edit) -> PATCH|PUT (update), DELETE (destroy)

# /articles/1/comments GET (index), (new) -> POST (create) 
# /articles/1/comments/1 GET (show), (edit) -> PATCH|PUT (update), DELETE (destroy)

# URI: uniform "RESOURCE" identifier
# URL: uniform "RESOURCE" locator

# Resources are noun based objects or things
# that can be identified by a URI
# and located by a URL 

# HTTP verbs
# (actions that you interact with a resource identified by a URL/URI)
# REST semantics: REpresentational State Transfer
# - GET
# - PATCH
# - POST
# - PUT
# - DELETE

# map to database verbs (CRUD) ...
# - Create: HTTP POST
# - Read:   HTTP GET
# - Update: HTTP PATCH, PUT 
# - Delete: HTTP DELETE

# in Rails resources often map to database records
# although common this is not a strict requirement

# Rails routes map to
# Actions which are methods defined on controllers

# User (resource backed by a model and database record)
# - create:  create  POST
# - update:  update  PATCH, PUT
# - show:    read    GET
# - destroy: delete  DELETE
# - sign_in:         POST - non-RESTful :(

# UserSession (resource not backed by a model or database record)
# - create:  create  POST
# - update:  update  PATCH, PUT
# - show:    read    GET
# - destroy: delete  DELETE