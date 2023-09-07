require 'delayed_job'
class DelayedDuplicatePreventionPlugin < Delayed::Plugin
 
  module SignatureConcern
    extend ActiveSupport::Concern

    included do
      before_validation :add_signature
      validate :prevent_duplicate
    end

    private

    def add_signature
      self.signature = generate_signature
      self.args = self.payload_object.args
    end

    def generate_signature
      pobj = payload_object
      if pobj.object.respond_to?(:id) and pobj.object.id.present?
        sig = "#{pobj.object.class}"
        sig += ":#{pobj.object.id}" 
      else
        sig = "#{pobj.object}"
      end
      
      sig += "##{pobj.method_name}"
      return sig
    end    

    def prevent_duplicate
      if DuplicateChecker.duplicate?(self)
        Rails.logger.warn "Found duplicate job(#{self.signature}), ignoring..."
        errors.add(:base, "This is a duplicate") 
      end
    end
  end

  class DuplicateChecker
    attr_reader :job

    def self.duplicate?(job)
      new(job).duplicate?
    end

    def initialize(job)
      @job = job
    end

    def duplicate?
      possible_dupes.any? { |possible_dupe| args_match?(possible_dupe, job) }
    end

    private

    def possible_dupes
      possible_dupes = Delayed::Job.where(attempts: 0, locked_at: nil)  # Only jobs not started, otherwise it would never compute a real change if the job is currently running
                                   .where(signature: job.signature)     # Same signature
      possible_dupes = possible_dupes.where.not(id: job.id) if job.id.present?
      possible_dupes
    end

    def args_match?(job1, job2)
      # TODO: make this logic robust
      normalize_args(job1.args) == normalize_args(job2.args)
    end

    def normalize_args(args)
      args.kind_of?(String) ? YAML.load(args) : args
    end
  end
end