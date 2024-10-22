class Wallet < ApplicationRecord
  belongs_to :user

  def as_json options={}
    {
      id: id,
      type: type,
      amount: amount,
      notes: notes,
      user: {
        id: user_id,
        username: user.username,
        name: user.name,
      }
    }
  end
end
