# -*- SkipSchemaAnnotations
class Communication::Website::Configs::NodcWorkflow < Communication::Website::Configs::Base

  def self.polymorphic_name
    'Communication::Website::Configs::NodcWorkflow'
  end

  def git_path(website)
    ".github/workflows/nodc.yml"
  end

  def template_static
    "admin/communication/websites/configs/nodc_workflow/static"
  end

end
