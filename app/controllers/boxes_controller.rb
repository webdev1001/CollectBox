require 'dropbox_sdk'

class BoxesController < ApplicationController
  before_action :set_box, only: [:show, :authenticate, :upload]

  def new
    @box = Box.new
  end

  def create
    @box = Box.new(box_params)
    if @box.save
      session[:dropbox_session] = dropbox_session.serialize
      redirect_to dropbox_session.get_authorize_url(authenticate_box_url(@box))
    end
  end

  def show
    dropbox_session = DropboxSession.deserialize(@box.dropbox_session)
    @dropbox_client = DropboxClient.new(dropbox_session)
  end

  def authenticate
    dropbox_session = DropboxSession.deserialize(session[:dropbox_session])
    @box.update(access_token: dropbox_session.get_access_token)

    session[:dropbox_session] = dropbox_session.serialize
    @box.update(dropbox_session: session[:dropbox_session])

    redirect_to @box
  end

  def upload
    dropbox_session = DropboxSession.deserialize(@box.dropbox_session)
    dropbox_client = DropboxClient.new(dropbox_session)

    params[:files].each do |uploaded_file|
      filename = "#{@box.folder_name}/#{uploaded_file.original_filename}"
      file = File.open(uploaded_file.tempfile)

      dropbox_client.put_file(filename, file)
    end

    render nothing: true
  end

  private

  def set_box
    @box ||= Box.find(params[:id])
  end

  def dropbox_session
    @dropbox_session ||= DropboxSession.new(
      Rails.application.secrets.app_key,
      Rails.application.secrets.app_secret
    )
  end

  def box_params
    params.require(:box).permit(:name)
  end

end
