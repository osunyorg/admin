module Admin::TasksHelper

  WARNING_THRESHOLD = 1000
  ALERT_THRESHOLD = 2000

  def background_tasks_counter_color(number_of_tasks)
    if number_of_tasks >= ALERT_THRESHOLD
      return 'text-danger' 
    elsif number_of_tasks >= WARNING_THRESHOLD
      return 'text-warning'
    else
      return 'text-white'
    end
  end

end