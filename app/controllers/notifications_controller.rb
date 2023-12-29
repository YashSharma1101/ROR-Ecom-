class NotificationsController < ApplicationController
	def index 
    @notifications = current_user.notifications
  end

  def mark_as_read
    notification = Notification.find(params[:id])
    notification.update(status: 'read')
    redirect_to root_path
  end

  def destroy
  	notification = Notification.find(params[:id])
  	notification.destroy
  	redirect_back(fallback_location: root_path)
  end

  def delete_all_noti
  	current_user.Notification.destroy.all
  	redirect_back(fallback_location: root_path)#, notice: "#{current_user.name} All notifications deleted successfully."
  end

	def batch_delete
    selected_notification_ids = params[:selected_notifications]
    Notification.where(id: selected_notification_ids).destroy_all if selected_notification_ids.present?
    redirect_to notifications_path, notice: 'Selected notifications were successfully deleted.'
  end
	def mark_all_as_read
    if params[:mark_all_as_read].present?
      Notification.update_all(read: true)
      redirect_to notifications_path, notice: 'All notifications marked as read.'
    else
      redirect_to notifications_path, alert: 'Invalid request for marking all as read.'
    end
  end

end
