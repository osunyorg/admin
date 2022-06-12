module Accessible
  extend ActiveSupport::Concern

  def accessible?
    accessibility_errors.empty?
  end

  def accessibility_merge(object)
    return unless object.respond_to?('accessible?')
    object.accessibility_warnings.each do |message|
      accessibility_warning message
    end
    object.accessibility_errors.each do |message|
      accessibility_error message
    end
  end

  def accessibility_errors
    check_accessibility_if_necessary
    @accessibility_errors
  end

  def accessibility_warnings
    check_accessibility_if_necessary
    @accessibility_warnings
  end

  protected

  def check_accessibility_if_necessary
    unless @accessibility_checked
      @accessibility_warnings = []
      @accessibility_errors = []
      check_accessibility
      @accessibility_checked = true
    end
  end

  def accessibility_checked?
    @accessibility_checked
  end

  # Override for some objects
  def check_accessibility
  end

  def accessibility_warning(key)
    @accessibility_warnings << key
  end

  def accessibility_error(key)
    @accessibility_errors << key
  end
end
