json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :date, :amount, :description, :image, :payer_id, :payee_id
  json.url transaction_url(transaction, format: :json)
end
