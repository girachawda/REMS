class Lease < ApplicationRecord
  belongs_to :user
  belongs_to :unit

  def activate!
    update!(active: true)
  end
end
