json.file_server do
  json.url @l10n.file_server_url
  json.base_url @l10n.file_server_base_directory_url
  json.slug @l10n.file_server_slug
  json.extension @l10n.file_server_extension
  json.endpoint change_server_slug_admin_communication_file_redirections_path(@file)
end
json.redirections do
  json.base_url @l10n.file_server_base_url
  json.endpoint admin_communication_file_redirections_path
  json.list @l10n.redirections.ordered do |redirection|
    json.id redirection.id
    json.url redirection.url
    json.endpoint admin_communication_file_redirection_path(id: redirection)
  end
end