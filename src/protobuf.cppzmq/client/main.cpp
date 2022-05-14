#include "event.pb.h"
#include <spdlog/spdlog.h>
#include <string>
#include <zmq.hpp>
#include <include/common.h>

int main()
{
    // initialize the zmq context with a single IO thread
    zmq::context_t context{ 1 };

    // construct a REQ (request) socket and connect to interface
    zmq::socket_t socket{ context, zmq::socket_type::req };
    socket.connect("tcp://localhost:5555");

    // set up some static data to send
    const std::string senderName{ "Client" };
    int32_t pingCount = 0;
    int32_t pongCount = 0;

    for (;;) {
        // send the request message
        own::proto::Event event;
        event.set_sender(senderName);
        event.set_action(own::proto::Event::PONG);
        event.set_ping_count(pingCount);
        event.set_pong_count(pongCount);

        std::string data;
        event.SerializeToString(&data);

        // send to the server
        socket.send(zmq::buffer(data), zmq::send_flags::none);

        // wait for reply from server
        zmq::message_t reply{};
        socket.recv(reply, zmq::recv_flags::none);

        own::proto::Event receivedEvent;
        receivedEvent.ParseFromArray(reply.data(), static_cast<int>(reply.size()));
        pingCount = receivedEvent.ping_count();
        pongCount = receivedEvent.pong_count() + 1;

        spdlog::info("Received from: {} Action: {} Ping count: {} Pong count: {}",
          receivedEvent.sender(),
          own::proto::Event_PingPong_Name(receivedEvent.action()),
          receivedEvent.ping_count(),
          receivedEvent.pong_count());

        if (receivedEvent.pong_count() == Common::maxCount) { break; }
    }

    return 0;
}
