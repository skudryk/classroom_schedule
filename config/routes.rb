Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "posts#index"
  
  namespace :api do
    resources :teachers
    resources :subjects
    resources :classrooms
    resources :students do
      member do
        get :schedule
        get :schedule_pdf
      end
    end
    resources :sections do
      member do
        post :enroll
        delete :unenroll
      end
      collection do
        get :available
        get :conflicts
      end
    end
    resources :enrollments
  end
end
