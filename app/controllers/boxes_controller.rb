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
    @dropbox_client = DropboxClient.new(dropbox_session)
    file = params[:file]
    @dropbox_client.put_file("#{@box.folder_name}/#{file.original_filename}", File.open(file.tempfile))
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
