class Image < ActiveRecord::Base
  has_attached_file :file
  validates_attachment_content_type :file, content_type: ['image/jpeg', 'image/pjpeg', 'image/png', 'image/x-png', 'image/gif']
end
