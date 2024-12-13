class TaskValidator
  def self.validate(task)
    errors = []
    errors << "Title must be a non-empty string" unless task.title.is_a?(String) && task.title.strip.present?
    errors << "Completed must be a boolean" unless [true, false].include?(task.completed)
    errors
  end
end
