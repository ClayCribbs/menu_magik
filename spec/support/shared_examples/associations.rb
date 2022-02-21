require 'rspec/expectations'

RSpec.shared_examples 'associates_with' do |model, relationship|
  it "it #{relationship} #{model}" do
    expect(described_class.reflect_on_association(model).macro).to eq(relationship)
  end
end
