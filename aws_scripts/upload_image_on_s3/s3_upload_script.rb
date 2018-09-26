require 'RMagick'
include Magick

def call_me
    s3_obj = Aws::S3::Client.new(access_key_id: ENV['S3_KEY'],secret_access_key: ENV['S3_SECRET'], region: ENV['S3_REGION'])
    s3 = Aws::S3::Resource.new(access_key_id: ENV['S3_KEY'],secret_access_key: ENV['S3_SECRET'], region: ENV['S3_REGION'])
    bucket = ENV['S3_BUCKET']
    prefix = "#{ENV['S3_PREFIX']}/uploads/primer/primer_image/"

    p ENV['S3_KEY']
    p ENV['S3_PREFIX']
    #obj = s3.buckets['development-venturit-in'].objects['Screen_Shot_2018-04-05_at_12.24.06_PM.png'] # no request made
    # puts "Path: #{prefix}/#{id}/#{key}"
    # s3_obj.put_object(bucket: bucket, key: "#{prefix}/#{id}/#{key}", body: body)
    my_bucket = s3.bucket(bucket).objects(prefix: prefix, delimiter: '').collect(&:key)
    #my_bucket = s3.bucket(bucket).with_prefix(prefix).collect(&:key)

    p "===== 3"
    p my_bucket
    a = []
    i = 0
    my_bucket.each do |f|
      i = i + 1
      filename = f.split('/')[-1]

      if (filename.include? "medium") || (filename.include? "thumb")
      	puts "already found - #{filename}"
      else
        id = f.split('/')[-2]

        s3_image_path = "https://s3.us-east-2.amazonaws.com/#{bucket}/#{prefix}#{id}/#{filename}"

      	image_size_array = resize_image(filename, s3_image_path) #  resize function call.

        image_size_array.each do |img_path|
        	#s3_obj.copy_object({bucket: bucket , copy_source: "#{copy_source}/#{id}/#{filename}", key: "staging/campusties/uploads/primer/primer_image/#{id}/medium_"+ filename})
					diff_filesize_name = img_path.split('/')[-1]
					copy_source = "staging/campusties/uploads/primer/primer_image/#{id}/#{diff_filesize_name}"

       		obj = s3.bucket(bucket).object(copy_source)
					obj.upload_file(img_path)
				end
      	a << f
      end

      # if i == 7
      #   break
      # end

    end
		# my_bucket.objects.limit(50).each do |item|
    #   puts "Name:  #{item.key}"
    # end
		render :json => {:explore_topics => a, :status => "success"}

  end

  def resize_image(img_name, s3_image_path)
      sizes = [{
      	idiom: 'medium',
      	size: 250,
      	scale: 1},
      	{
      	idiom: 'thumb',
      	size: 80,
      	scale: 1}]

			img = ImageList.new(s3_image_path)# "https://s3.us-east-2.amazonaws.com/nuteacher/staging/campusties/uploads/primer/primer_image/100/course-art-det-new.png")
      extension = File.extname(img_name)
      file_name_without_ext = File.basename(img_name, extension)
      # puts img_name
      # puts extension
      # puts file_name_without_ext

      image_array = []

      sizes.each do |f|

      	if f[:idiom] == 'thumb'
			  	puts "----thumb"
			    prefix_title = "thumb_#{img_name}"
			  end
			  if f[:idiom] == 'medium'
			  	puts "----medium"
			    prefix_title = "medium_#{img_name}"
			  end

			  if f[:idiom].include?('thumb') || f[:idiom].include?('medium')
			    #puts Rails.root

			    file_path = "#{Rails.root}/public/uploads/resize_images/"
			    Dir.mkdir(file_path) unless File.exists?(file_path)

			    size = f[:scale] * f[:size]
			    scaled_img = img.resize_to_fit(size, size)

			    filename = "#{file_path}" +  prefix_title #(s[:scale] > 1 ? prefix_title : "Icon-#{s[:size]}.png")
			    scaled_img.write(filename)

			    image_array << filename
			  end
      end
      return image_array
end
