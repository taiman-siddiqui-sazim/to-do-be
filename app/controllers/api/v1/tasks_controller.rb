module Api
  module V1
    class TasksController < ApplicationController
      before_action :set_task, only: [:show, :update, :update_completion, :destroy]

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

      def update
        if params[:task].keys.any? { |key| !task_update_params.key?(key) }
          render json: TaskSerializer.serialize_errors(
            ['Only task title can be updated'],
            metadata: metadata
          ), status: :unprocessable_entity
          return
        end

        @task.assign_attributes(task_update_params)
        validator = TaskValidator.new(@task)

        if validator.valid? && @task.save
          render json: TaskSerializer.serialize(
            @task,
            metadata: metadata
          ), status: :ok
        else
          render json: TaskSerializer.serialize_errors(
            validator.errors.presence || @task.errors.full_messages,
            metadata: metadata
          ), status: :unprocessable_entity
        end
      end

      def update_completion
        if params[:task].keys.any? { |key| !completion_update_params.key?(key) }
          render json: TaskSerializer.serialize_errors(
            ['Only the completed field can be updated'],
            metadata: metadata
          ), status: :unprocessable_entity
          return
        end

        @task.assign_attributes(completion_update_params)

        if @task.save
          render json: TaskSerializer.serialize(
            @task,
            metadata: metadata
          ), status: :ok
        else
          render json: TaskSerializer.serialize_errors(
            @task.errors.full_messages,
            metadata: metadata
          ), status: :unprocessable_entity
        end
      end

      def destroy
        if @task.destroy
          render json: { message: "Task successfully deleted", metadata: metadata }, status: :ok
        else
          render json: TaskSerializer.serialize_errors(
            @task.errors.full_messages,
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

      def task_update_params
        params.require(:task).permit(:title)
      end

      def completion_update_params
        params.require(:task).permit(:completed)
      end

      def build_metadata(extra_metadata = {})
        metadata.merge(extra_metadata)
      end
    end
  end
end