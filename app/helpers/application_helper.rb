module ApplicationHelper
  def qrcode(email)
    require "rqrcode"

    base_url = request.base_url + new_client_user_registration_path
    full_url = "#{base_url}?promoter=#{email}"

    qrcode = RQRCode::QRCode.new(full_url)

    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 11,
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
    # @percentage = ((@exam.score.to_f / @exam.total_score) * 100).round(2)
    percent = item.minimum_tickets / Item.where(batch_count: item.batch_count).count
  end
end
