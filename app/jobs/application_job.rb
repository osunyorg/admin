class ApplicationJob < ActiveJob::Base
  retry_on StandardError, wait: :polynomially_longer, attempts: Float::INFINITY

  discard_on  ActiveJob::DeserializationError # Discard if object does not exist anymore

  # https://github.com/bensheldon/good_job#concurrency-controls
  include GoodJob::ActiveJobExtensions::Concurrency

  # Define one or more concurrency rules. Each rule is scoped to a label,
  # which is a value derived from the job's arguments at enqueue time and
  # stored on the job record. Jobs must be enqueued with the matching label
  # via `good_job_labels:` for the rule to apply.
  #
  # Multiple rules can be defined; they are evaluated in order and the first
  # exceeded rule short-circuits the rest.
  good_job_concurrency_rule(
    # A label that scopes this rule. Can be a static String or a Lambda/Proc
    # invoked in the context of the job instance (see "Dynamic labels" below).
    # The rule only applies to jobs that were enqueued with this label in
    # `good_job_labels`.
    label: -> { "#{self.class.name}-#{queue_name}-#{digest_arguments(arguments)}" },

    # Apply the rule's label to every job of this class (and its subclasses),
    # so the jobs don't need to be enqueued with it. Defaults to false.
    # A Lambda/Proc label that returns nil is not applied.
    apply_label: true,

    # Maximum number of unfinished jobs with this label to allow.
    # Can be an Integer or Lambda/Proc invoked in the context of the job.
    total_limit: 1,

    # Or, if more control is needed:
    # Maximum number of jobs with this label to be concurrently enqueued
    # (excludes performing jobs). Can be an Integer or Lambda/Proc.
    enqueue_limit: 1,

    # Maximum number of jobs with this label to be concurrently performed
    # (excludes enqueued jobs). Can be an Integer or Lambda/Proc.
    perform_limit: 1,

    # Maximum number of jobs with this label to be enqueued within the time
    # period, looking backwards from now. Must be [count, period].
    enqueue_throttle: [10, 1.minute],

    # Maximum number of jobs with this label to be performed within the time
    # period, looking backwards from now. Must be [count, period].
    perform_throttle: [100, 1.hour],

    # Note: Under heavy load, the total number of jobs may exceed the
    # sum of `enqueue_limit` and `perform_limit` because of race conditions
    # caused by imperfectly disjunctive states. If you need to constrain
    # the total number of jobs, use `total_limit` instead. See #378.
  )

  before_enqueue :add_good_job_labels

  protected

  def good_job_additional_labels
    []
  end

  protected

  def add_good_job_labels
    return if good_job_additional_labels.empty?
    self.good_job_labels |= good_job_additional_labels
  end

  def digest_arguments(arguments)
    Digest::MD5.hexdigest(stringify_arguments_for_digest(arguments))
  end

  def stringify_arguments_for_digest(arguments)
    prepare_arguments_for_digest(arguments).join('|')
  end

  def prepare_arguments_for_digest(arguments)
    arguments.map { |argument|
      argument.is_a?(ActiveRecord::Base)  ? argument.to_global_id.to_s
                                          : argument.to_json
    }
  end


end
