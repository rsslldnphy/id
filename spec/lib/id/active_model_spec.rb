require 'spec_helper'
require 'support/active_model_lint'

class ActiveModelTest
  include Id::Model
  include Id::Form
end

describe ActiveModelTest do

  subject { ActiveModelTest.new.to_model }

  it_behaves_like "ActiveModel"
end
