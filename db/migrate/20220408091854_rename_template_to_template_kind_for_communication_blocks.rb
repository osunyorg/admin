class RenameTemplateToTemplateKindForCommunicationBlocks < ActiveRecord::Migration[6.1]
  def change
    rename_column :communication_blocks, :template, :template_kind
  end
end
