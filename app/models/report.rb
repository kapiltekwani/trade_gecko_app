class Report
  require 'csv'
  include Mongoid::Document

  mount_uploader :file, FileUploader

  validates :file, file_size: { less_than_or_equal_to: 2.megabytes },
                     file_content_type: { allow: ['text/csv'] } 

 
  after_save :process_file

  def process_file
    invalid_rows = []

    CSV.parse(File.read(file.path).gsub(/\\"/,'""'), :headers => true).each do |row|   
      current_object_state = ObjectState.new(object_id: row["object_id"], object_type: row["object_type"], object_changes: row["object_changes"]) 
      current_object_state.timestamp =  DateTime.strptime(row["timestamp"],'%s') if valid_timestamp?(row["timestamp"])
 
      if current_object_state.valid?
        previous_object_state = ObjectState.where(object_id: row["object_id"], object_type: row["object_type"]).order_by(:timestamp => 'desc').first
        current_object_state.object_changes = (JSON.parse(previous_object_state.object_changes).merge(JSON.parse(row["object_changes"]))).to_json if previous_object_state
        current_object_state.save 
      else
        #we can use collect invalid rows and send them as another attachment back to user.
        logger.debug "==#{row}"
        invalid_rows << row
      end
    end
  end

  def valid_timestamp?(timestamp)
    begin
      DateTime.strptime(timestamp, '%s')
      true
    rescue ArgumentError, StandardError
      false
    end    
  end 
end
