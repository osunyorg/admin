class Communication::Block::Template::Job::Element < Communication::Block::Template::Base

  has_component :id, :job

  def job
    id_component.job
  end
end
