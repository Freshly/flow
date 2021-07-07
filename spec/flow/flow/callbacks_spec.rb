# frozen_string_literal: true

RSpec.describe Flow::Flow::Callbacks, type: :concern do
  subject(:example_class) { Class.new.include described_class }

  it { is_expected.to include_module ActiveSupport::Callbacks }

  it_behaves_like "an example class with callbacks", described_class, %i[initialize trigger flux]
end
