class Lease < ApplicationRecord
  belongs_to :user
  belongs_to :unit
  has_one :utility

  def activate
    update!(active: true)
  end
end
