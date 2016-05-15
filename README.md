# Bolero: Multistep Forms for Rails

Bolero is a new way to implement Multistep or "Wizard"-type forms and workflows in Rails.  The goal of Bolero is to keep your controllers simple, to avoid storing partially created objects in your database, and to make it easy to make changes to the order or the contents of various steps of your forms.

## Getting Started

### Install the Gem

Add this to your Gemfile

```ruby
gem 'bolero-rails'
```

Then run `bundle install` to install the gem.

### 

Bolero stores partially created forms in your database.  
