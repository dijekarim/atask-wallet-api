class Wallet < ApplicationRecord
  belongs_to :source, class_name: 'User', optional: true
  belongs_to :target, class_name: 'User', optional: true

  def as_json options={}
    {
      id: id,
      type: type,
      amount: amount,
      notes: notes,
      user_id: user_id,
      source: {
        id: source_id,
        username: source.username,
        name: source.name,
      },
      target: (target_id ? {
        id: target_id,
        username: target.username,
        name: target.name,
      } : nil),
      transaction_type: transaction_type,
      created_at: created_at
    }
  end
end
