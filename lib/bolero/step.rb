module Bolero::Step
  def self.included base
    base.include(InstanceMethods)
    base.extend(ClassMethods)
    base.class_eval do
      include ActiveModel::Model
      cattr_accessor :persistent_accessors
      self.persistent_accessors = []
    end
  end


  module InstanceMethods
    def session=(session)
      @session = session
      persisted_step.session_id = session.id
    end

    def save
      return false unless valid?

      @session[:bolero_session_data] = @sensitive_data.to_yaml if @sensitive_data

      klass = self.class.to_s.classify
      completed_steps[klass] = { completed_at: Time.zone.now }

      persisted_step.save
    end


    def assign_attributes(params={})
      params.each do |attr, value|
        self.public_send("#{attr}=", value)
      end if params
    end

    def clear_persisted_data!
      persisted_step.destroy!
    end

    def url_helpers
      Rails.application.routes.url_helpers
    end

    def persisted_data
      persisted_step.persisted_data
    end

    def completed_steps
      persisted_step.completed_steps
    end

    def persisted_step
      @persisted_step ||= begin
        step = Bolero::PersistedStep.find_or_initialize_by(session_id: @session.id)
        step.persisted_data ||= {}
        step.completed_steps ||= {}

        if step.expired?
          step.persisted_data.clear
          step.completed_steps.clear
        end

        step
      end
    end

    def sensitive_data
      @sensitive_data ||= begin
        if @session[:bolero_session_data]
          YAML.load(@session[:bolero_session_data])
        else
          OpenStruct.new
        end
      end
    end
  end

  module ClassMethods
    def attr_bolero_reader(*args)
      args.each do |arg|
        define_method arg do
          persisted_data[arg.to_s]
        end
      end
    end

    def attr_bolero_writer(*args)
      args.each do |arg|
        define_method "#{arg}=" do |param|
          persisted_data[arg.to_s] = param
        end
      end
    end

    def attr_bolero_accessor(*args)
      args.each do |arg|
        define_method arg do
          persisted_data[arg.to_s]
        end
        define_method "#{arg}=" do |param|
          persisted_data[arg.to_s] = param
        end
      end
    end

    def attr_bolero_sensitive_reader(*args)
      args.each { |arg| delegate arg, to: :sensitive_data }
    end

    def attr_bolero_sensitive_writer(*args)
      args.each { |arg| delegate "#{arg}=", to: :sensitive_data }
    end

    def attr_bolero_sensitive_accessor(*args)
      args.each do |arg|
        delegate arg, to: :sensitive_data
        delegate "#{arg}=", to: :sensitive_data
      end
    end

    def has_one(name, args = {})
      foreign_key = args[:foreign_key] || "#{name}_id"
      class_name = args[:class_name] || name.to_s.classify

      define_method name do
        class_name.constantize.find_by(id: persisted_data[foreign_key])
      end
    end
  end
end
