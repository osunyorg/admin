module WithHugo
  extend ActiveSupport::Concern

  def hugo(website)
    @hugo ||= OpenStruct.new(
      path: hugo_path_in_website(website),
      file: hugo_file_in_website(website),
      slug: hugo_slug_in_website(website)
    )
  end

  protected

  def hugo_path_in_website(website)
    "#{current_permalink_in_website(website)&.path}"
  end
  
  def hugo_file_in_website(website)
    git_path(website)
  end

  def hugo_slug_in_website(website)
    slug
  end
end