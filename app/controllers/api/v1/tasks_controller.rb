module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [:show]

      def index
        result = PaginationService.paginate(Task, params)
        render json: TaskSerializer.serialize_collection(
          result[:records],
          metadata: build_metadata(result[:metadata])
        ), status: :ok
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

      def build_metadata(extra_metadata = {})
        {
          timestamp: Time.current,
          api_version: "v1"
        }.merge(extra_metadata)
      end
    end
  end
end
