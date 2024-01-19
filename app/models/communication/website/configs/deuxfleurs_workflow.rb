class Communication::Website::Configs::DeuxfleursWorkflow < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::DeuxfleursWorkflow'
  end

  def git_path(website)
    ".github/workflows/deuxfleurs.yml"
  end

  def template_static
    "admin/communication/websites/configs/deuxfleurs_workflow/static"
  end

end
