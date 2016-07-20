class Bolero::MissingStepError < StandardError
  def initialize(current_step:, missing_step:)
    @current_step = current_step
    @missing_step = missing_step
  end

  def missing_step_path
    @missing_step.to_s.constantize.new.path
  end
end
