RSpec.shared_examples 'validates presence of' do |required_fields|
  subject { FactoryBot.build(described_class.name.underscore.to_sym) }

  it 'is valid if required fields are present' do
    expect(subject).to be_valid
    expect(subject.errors).to be_empty
  end

  required_fields.each do |required_field|
    it "is invalid if #{required_field} is not present" do
      subject.send("#{required_field}=", '')

      expect(subject).not_to be_valid
      expect(subject.errors).to have_key(required_field)
    end

    it "is invalid if #{required_field} is set to nil" do
      subject.send("#{required_field}=", nil)

      expect(subject).not_to be_valid
      expect(subject.errors).to have_key(required_field)
    end
  end
end
