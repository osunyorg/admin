json.extract! @block,
              :template_kind,
              :published,
              :position,
              :data
heading = @block.heading
json.heading do
  json.extract! heading, :id, :title
end if heading