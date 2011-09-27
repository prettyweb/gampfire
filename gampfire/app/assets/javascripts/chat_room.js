window.chatroom = {
    update_message_lock: false,

    acquire_update_message_lock: function () {
        if (window.chatroom.update_message_lock == false) {
            window.chatroom.update_message_lock = true;
            return true;
        } else {
            return false;
        }
    },

    release_update_message_lock: function () {
        window.chatroom.update_message_lock = false;
    },

    from_message_id: 0,

    schedule_update_messages: function (from_message_id) {
        /* if there is already a scheduled update message timer, just ignore this one */
        if (window.chatroom.timer) {
            return;
        }

        window.chatroom.from_message_id = from_message_id;
        window.chatroom.timer = window.setTimeout(function () {
            window.chatroom.update_messages(from_message_id);
        }, 3000);
    },

    run_scheduled_update_messages: function () {
        if (window.chatroom.timer) {
            window.clearTimeout(window.chatroom.timer);
            window.chatroom.timer = null;
        }

        window.chatroom.update_messages(window.chatroom.from_message_id);
    },
        
    update_messages: function (from_message_id) {
        if (window.chatroom.timer) {
            window.clearTimeout(window.chatroom.timer);
            window.chatroom.timer = null;
        }

        /* another post is in progress */
        if (!window.chatroom.acquire_update_message_lock()) {
            return;
        }

        jQuery.post('get_message_update',
                    {
                        'from_id': from_message_id
                    },
                    function (data) {
                        window.chatroom.release_update_message_lock();
                        $('.messages').append(data);
                    },
                    'html'
                   );
    },
    start_chat_room: function () {
        var update_nickname = function (nickname) {
            $.ajax({
                url: 'update_nickname',
                type: 'post',
                data: {
                    'nickname': nickname
                },
                dataType: 'html',
                success: function (data) {
                    $('.user_list').html(data);
                }
            })
        }
        
        var modify_nickname = function () {
            var new_nickname = window.prompt('Input your new nickname', $('.user.current').html().trim());
            update_nickname(new_nickname);
        }
        
        var update_user_list = function () {
            $.ajax({
                url: 'get_user_list',
                type: 'get',
                dataType: 'html',
                success: function (data) {
                    $('.user_list').html(data);
                }
            });
        }
        
        var post_message = function (message) {
            if (message == '') {
                return;
            }

            jQuery.post('messages', 
                        {
                            'body': message
                        },
                        function (data) {
                            $('.errors').html(data);
                            window.chatroom.run_scheduled_update_messages();
                        },
                        'html'
                       );
        };

        var click_send_message_button = function () {
            var message = $('textarea.new_message').val();
            $('textarea.new_message').val('');
            post_message(message);
        }
        
        $(document).ready(function () {
            window.setInterval(update_user_list, 2000);
            
            window.chatroom.update_messages(0);
            
            // window.setInterval(update_messages, 1000);
            
            $('#new_message_button').click(click_send_message_button);
            $('textarea.new_message').bind('keypress', function (e) {
                if (e.keyCode == 13) {
                    click_send_message_button();
                    return false;
                }
            });
            
            $('.user.current').live('click', modify_nickname);
        });
    }
};

window.chatroom.start_chat_room();
