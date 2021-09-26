module ApplicationHelper
  def variant_for_status(status)
    variant_hash = {
      Import::ON_HOLD => 'warning',
      Import::PROCESSING => 'warning',
      Import::FAILED => 'danger',
      Import::TERMINATED => 'success'
    }

    variant_hash[status]
  end
end
