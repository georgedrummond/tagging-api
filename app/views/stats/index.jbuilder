json.array!(@tags) do |tag|
  json.name tag.name
  json.count tag.tagged_items.count
end
