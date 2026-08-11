class Osuny::Picker::Communication::Website::Post < Osuny::Picker

  def website
    context
  end

  def objects
    @objects ||= website.posts
  end

  def categories
    @categories ||= website.post_categories
  end

end