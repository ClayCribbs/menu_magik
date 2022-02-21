require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validate' do
    include_examples 'validates presence of', [ #required field
                                                :city,
                                                :country,
                                                :name,
                                                :phone_number,
                                                :postal_code,
                                                :region,
                                                :status,
                                                :street_address,
                                              ]
  end
end
