json.created do
  json.partial! "api/osuny/communication/websites/agenda/events/event", collection: @successfully_created_events, as: :event
end
json.updated do
  json.partial! "api/osuny/communication/websites/agenda/events/event", collection: @successfully_updated_events, as: :event
end
json.errors do
  json.array! @invalid_events_with_index do |invalid_event_with_index|
    json.index invalid_event_with_index[:index]
    json.errors invalid_event_with_index[:event].errors
  end
end