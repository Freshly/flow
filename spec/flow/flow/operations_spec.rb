# frozen_string_literal: true

RSpec.describe Flow::Flow::Operations, type: :concern do
  include_context "with example flow having state"

  describe ".operations" do
    subject(:operations) { example_flow_class.__send__(:operations, new_operations) }

    let(:new_operations) { [ double, double ] }

    it "changes _operations" do
      expect { operations }.to change { example_flow_class._operations }.from([]).to(new_operations)
    end
  end

  describe ".inherited" do
    it_behaves_like "an inherited property", :operations do
      let(:root_class) { example_flow_class }
    end
  end
end
