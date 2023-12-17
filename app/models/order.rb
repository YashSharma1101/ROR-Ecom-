class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  enum status: { cart: 0, ordered: 1, shipped: 2, out_for_delivery: 3, delivered: 4 }
  validate :valid_status_transition
  after_update :create_order_notification
  before_destroy :copy_to_order_history
  before_destroy :delete_associated_notifications

  def self.total_price_over_time
    group_by_day(:created_at).sum(:total_price)
  end
  
  def valid_status_transition
    if status_changed? && status_was.present?
      unless status_changed_from_cart?(status_was) && status_changed_to_ordered? ||
             status_changed_from_ordered?(status_was) && status_changed_to_shipped? ||
             status_changed_from_shipped?(status_was) && status_changed_to_out_for_delivery? ||
             status_changed_from_out_for_delivery?(status_was) && status_changed_to_delivered?
        errors.add(:status, "Invalid Status Transition.")
      end
    end
  end

  def status_changed_from_cart?(previous_status)
    previous_status.to_sym == :cart
  end

  def status_changed_to_ordered?
    status.to_sym == :ordered
  end

  def status_changed_from_ordered?(previous_status)
    previous_status.to_sym == :ordered
  end

  def status_changed_to_shipped?
    status.to_sym == :shipped
  end

  def status_changed_from_shipped?(previous_status)
    previous_status.to_sym == :shipped
  end

  def status_changed_to_out_for_delivery?
    status.to_sym == :out_for_delivery
  end

  def status_changed_from_out_for_delivery?(previous_status)
    previous_status.to_sym == :out_for_delivery
  end

  def status_changed_to_delivered?
    status.to_sym == :delivered
  end
  private

  def create_order_notification
    Notification.create(
      user_id: user_id,
      content: "Your order ##{id} has been #{status}.",
      order_id: id
    )
  end

  def copy_to_order_history
    OrderHistory.create(
      user_id: self.user_id,
      total_price: self.total_price,
      status: self.status
    )
  end

  def delete_associated_notifications
    Notification.where(order_id: id).destroy_all
  end

end
