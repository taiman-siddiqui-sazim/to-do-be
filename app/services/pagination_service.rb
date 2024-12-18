class PaginationService
    def self.paginate(relation, params)
      per_page = params[:per_page].to_i
      if per_page == 0
        all_records = relation.all
        {
          records: all_records,
          metadata: {
            total_records: all_records.count,
            page: 1,
            per_page: all_records.count,
            total_pages: 1
          }
        }
      else
        page = params.fetch(:page, 1).to_i
        per_page = params.fetch(:per_page, 10).to_i
        paginated = relation.page(page).per(per_page)
        {
          records: paginated,
          metadata: {
            total_records: relation.count,
            page: page,
            per_page: per_page,
            total_pages: paginated.total_pages
          }
        }
      end
    end
  end
  