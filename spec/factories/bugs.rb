FactoryGirl.define do
  factory :bug do
    title "test bug"
		details "this is a test bug"
		bugster "Kyle Noble"
		email "kyle@test.com"
		status "Reported"
		org 146 
		category "Email" 
		priority "Non-Service Impact"
		reporter "Thomas Jefferson"
		task_id 1134234343445
  end
end
