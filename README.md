# Bolero: Multistep Forms for Rails

Bolero is a new way to implement Multistep or "Wizard"-type forms and workflows in Rails.  The goal of Bolero is to keep your controllers simple, to avoid storing partially created objects in your database, and to make it easy to make changes to the order or the contents of various steps of your forms.

## Getting Started

### Install the Gem

Add this to your Gemfile

```ruby
gem "bolero", github: "bitpeel/bolero"
```

Then run `bundle install` to install the gem.

### Run the generator and migrate your database

```sh
rails g bolero:install
rake db:migrate
```

### Define your routes

Define your routes in `routes.rb` using any convention you like.

```ruby
...
namespace :signup do
  get "username", to: "username#new"
  post "username, to: "username#create"

  get "details", to: "details#new"
  post "details", to: "details#create"
  
  ...
end
...
```

### Create your controllers
```ruby
class Signup::UsernameController < ApplicationController
  def new
    @step = UsernameStep.new(session: session)
  end
  
  def create
    @step = UsernameStep.new(session: session)
    @step.assign_attributes(username_params)
    
    if @step.save
      redirect_to @step.next_path
    else
      render :new
    end
  end
  
  private
    def username_params
      params.require(:username_step).permit(:username, :email, :password)
    end
end
```

### Create your views
```ruby
  <%= simple_form_for @step, url: signup_username_path, method: :post do |f| %>
    <%= f.input :username %>
    <%= f.input :password %>
    <%= f.input :email %>
  <% end %>
```


### Create your step

`app/multisteps/signup/username_step.rb`

```ruby
class Signup::UsernameStep
  include Bolero::Step
  
  attr_bolero_accessor :username, :password, :email
  
  validates :username, presence: true, length: { minimum: 4, maximum: 30 }
  validate :email, presence: true
  validates :password, presence: true
  
  def path
    url_helpers.signup_username_path
  end

  def next_step_path
    url_helpers.signup_details_path
  end
end
```

