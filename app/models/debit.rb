class Debit < Wallet
  belongs_to :source, class_name: 'User', optional: true
  belongs_to :target, class_name: 'User', optional: true
end
