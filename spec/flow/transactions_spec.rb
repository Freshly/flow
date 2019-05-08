# frozen_string_literal: true

RSpec.describe Flow::Transactions, type: :module do
  include_context "with example flow having state", [
    Flow::TransactionWrapper,
    Flow::Operations,
    Flow::Flux,
    described_class,
  ]

  it_behaves_like "a transaction wrapper" do
    let(:example_class) { example_flow_class }
    let(:example_instance) { example_flow }

    it_behaves_like "method is wrapped in a transaction", :flux!, :flux, :_flux
  end
end
