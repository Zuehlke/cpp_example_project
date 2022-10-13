#include "event.pb.h"
#include <include/common.h>
#include <spdlog/spdlog.h>
#include <string>
#include <zmq.hpp>

int main()
{
    // initialize the zmq context with a single IO thread
    zmq::context_t context{ 1 };

    // construct a REQ (request) socket and connect to interface
    zmq::socket_t socket{ context, zmq::socket_type::req };
    socket.connect("tcp://127.0.0.1:5555");

    // set up some static data to send
    const std::string senderName{ "Client" };

    zmq::message_t request{};
    // send the request message
    auto [sendEvent, serializedData] = Common::prepareMessage(senderName, request);

    for (;;) {
        // send to the server
        socket.send(zmq::buffer(serializedData), zmq::send_flags::none);

        // wait for reply from server
        socket.recv(request, zmq::recv_flags::none);
        const auto [receivedEvent, _] = Common::prepareMessage(senderName, request);
        serializedData = Common::incrementPingPong(sendEvent, own::proto::Event::PONG);
        sendEvent = receivedEvent;
        Common::logProtoEvent(receivedEvent);

        if (receivedEvent.pong_count() == Common::maxCount) { break; }
    }

    return 0;
}
