module Api
    module V1
      class TasksController < ApplicationController
        before_action :set_task, only: [:show]
  
        def index
          tasks = Task.all
          render json: tasks
        end
  
        def show
          render json: @task
        end
  
        def create
          task = Task.new(task_params)
  
          errors = TaskValidator.validate(task)
          if errors.empty? && task.save
            render json: task, status: :created
          else
            render json: { error: errors.presence || task.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        private

        def set_task
          @task = Task.find(params[:id])
        end
  
        def task_params
          params.require(:task).permit(:title, :completed)
        end
      end
    end
  end
  