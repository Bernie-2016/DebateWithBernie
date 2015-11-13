class Image < ActiveRecord::Base
  do_not_validate_attachment_file_type :file
  has_attached_file :file
end
