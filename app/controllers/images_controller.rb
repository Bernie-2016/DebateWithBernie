class ImagesController < ApplicationController
  def create
    image = Image.new(image_params)
    if image.save
      render json: image
    else
      render json: { error: true }
    end
  end

  def show
    @image = Image.find(params[:id])
  end

  def public
    @image = Image.find(params[:id])
  end

  def download
    image = Image.find(params[:image_id])
    send_data open(image.file.url) { |f| f.read }, filename: 'debatewithbernie.png'
  end

  private

  def image_params
    params.require(:image).permit(:file)
  end
end
