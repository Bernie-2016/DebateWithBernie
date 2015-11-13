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

  private

  def image_params
    params.require(:image).permit(:file)
  end
end
