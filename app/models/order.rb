class Order < ApplicationRecord
  belongs_to :user

  validates_presence_of :status, :user_id
end
