class Communication::Block::Component::Job < Communication::Block::Component::Base

  def job
    return unless website
    website.jobboard_jobs
           .published_now_in(template.block.language)
           .find_by(id: data)
  end

  def dependencies
    [job]
  end

end
