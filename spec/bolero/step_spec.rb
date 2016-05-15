require 'spec_helper'

describe Bolero::Step do
  class StepObject
    include Bolero::Step
  end

  let(:step_object) { StepObject.new }

  context "imports instance methods" do
    it 'responds to session_id=' do
      expect(step_object).to respond_to(:session_id=)
    end

    it 'responds to save' do
      expect(step_object).to respond_to(:save)
    end

    it "imports url helpers" do
      expect(step_object).to respond_to(:url_helpers)
    end
  end

  context "imports class methods" do
    it "responds to attr_persistent_accessor" do
      expect(StepObject).to respond_to(:attr_persistent_accessor)
    end

    it "imports ActiveModel::Model methods" do
      expect(StepObject).to respond_to(:validates)
    end
  end

  context "attr_persistent_accessor" do
    class StepObject
      attr_persistent_accessor :foo, :foo2
      attr_persistent_accessor :foo3
    end

    it "uninitialized accessor starts as nil" do
      expect(step_object.foo).to be_nil
    end

    it "sets and retrieves values" do
      step_object.foo = 'bar'
      expect(step_object.foo).to eq 'bar'
    end

    it "accepts multiple accessors in single line" do
      expect(step_object).to respond_to(:foo2)
      expect(step_object).to respond_to(:foo2=)
    end

    it "accept accessors on multiple lines" do
      expect(step_object).to respond_to(:foo3)
      expect(step_object).to respond_to(:foo3=)
    end

    it "retains array of persisted accessors" do
      expect(StepObject.persistent_accessors).to eq [:foo, :foo2, :foo3]
    end
  end
end
