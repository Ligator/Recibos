json.array!(@payments) do |payment|
  json.extract! payment, :id, :user_transaction_id, :programmed_date, :done_date, :amount, :confirm_payer, :confirm_payee
  json.url payment_url(payment, format: :json)
end
