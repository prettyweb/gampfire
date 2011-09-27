class RoomsController < ApplicationController
  def get_message_update
    @room = Room.find_by_id(params[:id])
    @user = User.where('room_id = ? AND auth_code = ?', params[:id], params[:auth_code]).limit(1).first
    latest_message = Message.where('room_id = ?', params[:id]).order('id DESC').limit(1).first
    
    if latest_message.nil?
      new_from_message_id = 0
    else
      new_from_message_id = latest_message.id
    end

    messages = Message.where('room_id = ? AND id > ? AND id <= ?', params[:id], params['from_id'], new_from_message_id).order('id DESC').limit(200);
    return render :partial => 'get_messages', :locals => {:messages => messages, :new_from_message_id => new_from_message_id}
  end

  def new_message
    @room = Room.find_by_id(params[:id])
    @user = User.where('room_id = ? AND auth_code = ?', params[:id], params[:auth_code]).limit(1).first
    @message = Message.new
    @message.body = params[:body]
    @message.room = @room
    @message.user = @user
    @message.save
    return render :partial => 'errors', :locals => {:errors => @message.errors}
  end

  def update_nickname
    @room = Room.find_by_id(params[:id])
    @user = User.where('room_id = ? AND auth_code = ?', params[:id], params[:auth_code]).limit(1).first
    @user.nickname = params[:nickname]
    @user.save
    render  :partial => 'users_list', :locals => {:users => @room.users}
  end

  # check auth code, and show UI
  def chat
    @room = Room.find_by_id(params[:id])
    @user = User.where('room_id = ? AND auth_code = ?', params[:id], params[:auth_code]).limit(1).first
  end

  def invite
    @room = Room.find_by_id(params[:id])
    @user = User.invite_to_room(@room)
  end

  def get_latest_message_id
    @room = Room.find_by_id(params[:id])
    @message = Message.where('room_id = ?', @room.id).order('id DESC').limit(1).first
    return render :json => @message.id
  end

  def get_user_list
    @room = Room.find_by_id(params[:id])
    @user = User.where('room_id = ? AND auth_code = ?', params[:id], params[:auth_code]).limit(1).first
    render  :partial => 'users_list', :locals => {:users => @room.users}
  end

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rooms }
    end
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @room = Room.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @room }
    end
  end

  # GET /rooms/new
  # GET /rooms/new.json
  def new
    @room = Room.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @room }
    end
  end

  # GET /rooms/1/edit
  def edit
    @room = Room.find(params[:id])
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(params[:room])

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: 'Room was successfully created.' }
        format.json { render json: @room, status: :created, location: @room }
      else
        format.html { render action: "new" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rooms/1
  # PUT /rooms/1.json
  def update
    @room = Room.find(params[:id])

    respond_to do |format|
      if @room.update_attributes(params[:room])
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room = Room.find(params[:id])
    @room.destroy

    respond_to do |format|
      format.html { redirect_to rooms_url }
      format.json { head :ok }
    end
  end
end
