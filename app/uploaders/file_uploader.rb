class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick  

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end
  
  def extension_white_list
    %w(csv)
  end
end

