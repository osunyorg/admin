class JoinCategoriesToEvents < ActiveRecord::Migration[7.1]
  def change

  create_table "communication_website_agenda_events_categories", id: false, force: :cascade do |t|
    t.uuid "communication_website_agenda_event_id", null: false
    t.uuid "communication_website_category_id", null: false
    t.index ["communication_website_category_id", "communication_website_agenda_event_id"], name: "category_event"
    t.index ["communication_website_agenda_event_id", "communication_website_category_id"], name: "event_category"
  end
  end
end
