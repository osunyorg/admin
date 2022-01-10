class University::Person::Author < University::Person
  def self.polymorphic_name
    'University::Person::Author'
  end

  def git_path(website)
    "content/authors/#{slug}/_index.html" if for_website?(website)
  end

  def for_website?(website)
    is_author && communication_website_posts.published
                                            .where(communication_website_id: website&.id)
                                            .any?
  end
end
