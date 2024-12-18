class Task < ApplicationRecord
    validates :title, presence: true, allow_blank: false
    validates :completed, inclusion: { in: [true, false], message: "must be a boolean" }
end
