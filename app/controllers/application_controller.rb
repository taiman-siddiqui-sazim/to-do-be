module Api
    module V1
      class TasksController < ApplicationController
        before_action :set_task, only: [:show, :update, :destroy]
  
        # GET /api/v1/tasks
        def index
          tasks = Task.all
          render json: tasks
        end
  
        # GET /api/v1/tasks/:id
        def show
          render json: @task
        end
  
        # POST /api/v1/tasks
        def create
          task = Task.new(task_params)
          if task.save
            render json: task, status: :created
          else
            render json: { error: task.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # PUT /api/v1/tasks/:id
        def update
          if @task.update(task_params)
            render json: @task
          else
            render json: { error: @task.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # DELETE /api/v1/tasks/:id
        def destroy
          @task.destroy
          head :no_content
        end
  
        private
  
        def set_task
          @task = Task.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Task not found" }, status: :not_found
        end
  
        def task_params
          params.require(:task).permit(:title, :completed)
        end
      end
    end
  end  
