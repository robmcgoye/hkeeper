class LineItem < ApplicationRecord
  belongs_to :statement

  monetize :amount_cents

end