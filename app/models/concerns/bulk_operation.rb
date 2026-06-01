module BulkOperation
  IN_PROGRESS_KEY = :osuny_bulk_operation_in_progress

  def self.in_progress?
    Thread.current[IN_PROGRESS_KEY] == true
  end

  def self.silently(&block)
    previous = Thread.current[IN_PROGRESS_KEY]
    Thread.current[IN_PROGRESS_KEY] = true
    ActiveRecord::Base.transaction(&block)
  ensure
    # To allow nested calls of silently
    # Only the first call resets to false
    Thread.current[IN_PROGRESS_KEY] = previous
  end
end
