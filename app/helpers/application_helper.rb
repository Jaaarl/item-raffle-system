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
end
