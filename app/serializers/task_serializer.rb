class TaskSerializer
  def self.serialize(task, metadata: {})
    {
      data: {
        id: task.id,
        title: task.title,
        completed: task.completed,
        created_at: task.created_at,
        updated_at: task.updated_at
      },
      metadata: metadata
    }
  end

  def self.serialize_collection(tasks, metadata: {})
    {
      data: tasks.map do |task|
        {
          id: task.id,
          title: task.title,
          completed: task.completed,
          created_at: task.created_at,
          updated_at: task.updated_at
        }
      end,
      metadata: metadata
    }
  end

  def self.serialize_errors(errors, metadata: {})
    {
      error: errors,
      metadata: metadata
    }
  end
end
