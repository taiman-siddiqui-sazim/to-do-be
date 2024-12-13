module Api
    module V1
      class TasksController < ApplicationController
        before_action :set_task, only: [:show]
  
        def index
            result = paginate(Task)
            render json: {
              data: TaskSerializer.serialize_collection(result[:records]),
              metadata: result[:metadata].merge(timestamp: Time.current, api_version: "v1")
            }, status: :ok
        end
  
        def show
          render json: TaskSerializer.serialize(
            @task,
            metadata: metadata
          ), status: :ok
        end
  
        def create
          task = Task.new(task_params)
          validator = TaskValidator.new(task)
  
          if validator.valid? && task.save
            render json: TaskSerializer.serialize(
              task,
              metadata: metadata
            ), status: :created
          else
            render json: TaskSerializer.serialize_errors(
              validator.errors.presence || task.errors.full_messages,
              metadata: metadata
            ), status: :unprocessable_entity
          end
        end
  
        private
  
        def set_task
          @task = Task.find(params[:id])
        end
  
        def task_params
          params.require(:task).permit(:title, :completed)
        end

        def paginate(relation)
            page = params.fetch(:page, 1).to_i
            per_page = params.fetch(:per_page, 10).to_i
            paginated = relation.page(page).per(per_page)
            {
              records: paginated,
              metadata: {
                total_records: relation.count,
                page: page,
                per_page: per_page,
                total_pages: paginated.total_pages
              }
            }
        end
  
        def build_metadata(extra_metadata = {})
          metadata.merge(extra_metadata)
        end
      end
    end
  end
  