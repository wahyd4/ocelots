/**
 * Created with JetBrains RubyMine.
 * User: junv
 * Date: 12/5/12
 * Time: 12:59 PM
 * To change this template use File | Settings | File Templates.
 */
$(document).ready(function(){

    var dispatcher = new WebSocketRails('localhost:3000/websocket');
    dispatcher.use_websockets = false;

    dispatcher.on_open = function(data) {
        console.log('Connection has been established: ');
        console.log(dispatcher)
    }
    $('.submit-mess').click(function(){
        if ($('#content').val().replace(/\s+/, "") == ""){
            return ;
        }
        params= {};
        params.content = $('#content').val();
        params.slug = $('#slug').val()
        dispatcher.trigger('new_message',params);


    });

    dispatcher.bind('new_message', function(content) {
        $('#content').val("");
        $('.message-list').prepend(content).show('slow');
    });


});

