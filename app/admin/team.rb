ActiveAdmin.register Team do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  index do
    selectable_column
    column :name
    column :direct_feedbacks_count
    column :channel_feedbacks_count
    column :created_at
    column :last_feedback_at, sortable: :updated_at do |team|
      team.updated_at
    end
    column :trial_valid_until
  end
end
