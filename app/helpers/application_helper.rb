module ApplicationHelper
  def qrcode(email)
    require "rqrcode"

    base_url = request.base_url + new_client_user_registration_path
    full_url = "#{base_url}?promoter=#{email}"

    qrcode = RQRCode::QRCode.new(full_url)

    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 7,
      standalone: true,
      use_path: true
    )

    svg.html_safe
  end

  def invite_url_link(email)
    base_url = request.base_url + new_client_user_registration_path
    full_url = "#{base_url}?promoter=#{email}"

    full_url
  end

  def parent_id(email)
    user = User.find_by(email: email)
    if user
      user.id
    else
      nil
    end
  end

  def percentage(item)
    total_tickets = Ticket.where(batch_count: item.batch_count, item_id: item.id).count
    percentage = (total_tickets.to_f / item.minimum_tickets) * 100
    percentage.round(2)
  end

  def next_level_message(current_client_user)
    next_level = current_client_user.member_level.level + 1
    next_level_content = MemberLevel.find_by(level: next_level)

    if next_level_content
      required_members = next_level_content.required_members
      children_members = current_client_user.children_members
      coins = next_level_content.coins

      "Share this to #{required_members - children_members} friend/s and get #{coins} coins"
    else
      "No next level available"
    end
  end
end
