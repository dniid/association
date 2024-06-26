class PaginationViewModel
  DEFAULT = { page: 1, per_page: 10 }.freeze

  attr_reader :page, :count, :per_page

  def initialize(params = {})
    @page     = (params[:page] || DEFAULT[:page]).to_i
    @count    = params[:count]
    @per_page = params[:per_page] || DEFAULT[:per_page]
  end

  # TODO: This doesn't seem to belong here, move it to another place later
  def append_query_param(url, param)
    uri = URI.parse(url)

    uri.query.present? ? "#{url}&#{param}" : "#{url}?#{param}"
  end

  def offset
    return 0 if page == 1

    per_page * (page.to_i - 1)
  end

  def next_page
    page + 1 unless last_page?
  end

  def next_page?
    page < total_pages
  end

  def previous_page
    page - 1 unless first_page?
  end

  def previous_page?
    page > 1
  end

  def last_page?
    page == total_pages
  end

  def first_page?
    page == 1
  end

  def total_pages
    (count / per_page.to_f).ceil
  end
end
