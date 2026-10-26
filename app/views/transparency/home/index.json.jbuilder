json.contributions do
  json.total @contributions_total
  json.list @universities do |instance|
    json.id instance.id
    json.name instance.to_s
    json.amount instance.contribution_amount
    json.since instance.invoice_date
    json.logo instance.logo.url
  end
end
json.costs do
  json.total @costs_total
  json.list @costs do |cost|
    json.name cost.name
    json.description cost.description
    json.amount cost.annual_amount
  end
end
json.balance @balance
