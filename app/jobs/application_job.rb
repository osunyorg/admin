class ApplicationJob < ActiveJob::Base
  retry_on StandardError, wait: :exponentially_longer, attempts: Float::INFINITY

  # https://github.com/bensheldon/good_job?tab=readme-ov-file#labelled-jobs
  include GoodJob::ActiveJobExtensions::Labels

  include GoodJob::ActiveJobExtensions::Concurrency

  good_job_control_concurrency_with(
    # Maximum number of unfinished jobs to allow with the concurrency key
    # Can be an Integer or Lambda/Proc that is invoked in the context of the job
    # total_limit: 1,

    # Or, if more control is needed:
    # Maximum number of jobs with the concurrency key to be
    # concurrently enqueued (excludes performing jobs)
    # Can be an Integer or Lambda/Proc that is invoked in the context of the job
    enqueue_limit: 1,

    # Maximum number of jobs with the concurrency key to be
    # concurrently performed (excludes enqueued jobs)
    # Can be an Integer or Lambda/Proc that is invoked in the context of the job
    perform_limit: 1,

    # Maximum number of jobs with the concurrency key to be enqueued within
    # the time period, looking backwards from the current time. Must be an array
    # with two elements: the number of jobs and the time period.
    enqueue_throttle: [10, 1.minute],

    # Maximum number of jobs with the concurrency key to be performed within
    # the time period, looking backwards from the current time. Must be an array
    # with two elements: the number of jobs and the time period.
    perform_throttle: [100, 1.hour],

    # Note: Under heavy load, the total number of jobs may exceed the
    # sum of `enqueue_limit` and `perform_limit` because of race conditions
    # caused by imperfectly disjunctive states. If you need to constrain
    # the total number of jobs, use `total_limit` instead. See #378.

    # A unique key to be globally locked against.
    # Can be String or Lambda/Proc that is invoked in the context of the job.
    #
    # If a key is not provided GoodJob will use the job class name.
    #
    # To disable concurrency control, for example in a subclass, set the
    # key explicitly to nil (e.g. `key: nil` or `key: -> { nil }`)
    #
    # If you provide a custom concurrency key (for example, if concurrency is supposed
    # to be controlled by the first job argument) make sure that it is sufficiently unique across
    # jobs and queues by adding the job class or queue to the key yourself, if needed.
    #
    # Note: When using a model instance as part of your custom concurrency key, make sure
    # to explicitly use its `id` or `to_global_id` because otherwise it will not stringify as expected.
    #
    # Note: Arguments passed to #perform_later can be accessed through Active Job's `arguments` method
    # which is an array containing positional arguments and, optionally, a kwarg hash.
    key: -> { "#{self.class.name}-#{queue_name}-#{digest_arguments(arguments)}" }
  )

  private

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
