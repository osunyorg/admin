# frozen_string_literal: true

class AddSignatureToDelayedJob < ActiveRecord::Migration[7.0]
  def change
    add_column :delayed_jobs, :signature, :string
    add_column :delayed_jobs, :args, :text
  end
end