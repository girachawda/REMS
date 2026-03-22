# Tracks utility costs (electricity, water, gas, etc) for a lease
class Utility < ApplicationRecord
  belongs_to :lease
end
