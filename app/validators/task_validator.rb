class TaskValidator
  attr_reader :errors

  def initialize(task)
    @task = task
    @errors = []
  end

  def valid?
    validate_title
    validate_completed
    errors.empty?
  end

  private

  def validate_title
<<<<<<< HEAD
    if @task.title.blank? || !@task.title.is_a?(String)
=======
    if @task.title.blank? || !@task.title.is_a?(String) || @task.title.strip.empty?
>>>>>>> TD-15-task-complete
      @errors << "Title must be a non-empty string"
    end
  end

  def validate_completed
    if @task.completed != false
      @errors << "Completed must be set to false on creation"
    end
  end
end
