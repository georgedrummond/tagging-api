json.id @tagged_item.id
json.entity_type @tagged_item.entity_type
json.entity_identifier @tagged_item.entity_identifier

json.tags @tagged_item.tags.collect(&:name)
