class ProcessContactImportJob < ApplicationJob
  queue_as :default

  def perform(import_id)
		import = Import.find(import_id)

		import.update!(status: Import::PROCESSING)
  end
end