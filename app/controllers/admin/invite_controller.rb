class Admin::InviteController < Admin::BaseController

  def index
    @clients = User.where(role: 'client').where.not(parent: nil)

    @clients = @clients.joins('LEFT OUTER JOIN `users` `parent` ON `parent`.`id` = `users`.`parent_id`')
                       .where('parent.email LIKE ?', "%#{params[:parent_email]}%") if params[:parent_email].present?
  end
end