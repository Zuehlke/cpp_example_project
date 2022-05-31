#include "event.pb.h"
#include <chrono>
#include <include/common.h>
#include <spdlog/spdlog.h>
#include <thread>
#include <zmq.hpp>

int main()
{
    using namespace std::chrono_literals;

    // initialize the zmq context with a single IO thread
    zmq::context_t context{ 1 };

    // construct a REP (reply) socket and bind to interface
    zmq::socket_t socket{ context, zmq::socket_type::rep };
    socket.bind("tcp://*:5555");

    // prepare some static data for responses
    const std::string senderName{ "Server" };

    for (;;) {
        zmq::message_t request;

        // receive a request from client
        socket.recv(request, zmq::recv_flags::none);
        own::proto::Event receivedEvent;
        receivedEvent.ParseFromArray(request.data(), static_cast<int>(request.size()));

        // simulate work
        std::this_thread::sleep_for(500ms);
        own::proto::Event event;
        event.set_sender(senderName);
        event.set_action(own::proto::Event::PING);
        event.set_ping_count(receivedEvent.ping_count() + 1);
        event.set_pong_count(receivedEvent.pong_count());

        std::string data;
        event.SerializeToString(&data);

        // send the reply to the client
        socket.send(zmq::buffer(data), zmq::send_flags::none);

        spdlog::info("Received from: {} Action: {} Ping count: {} Pong count: {}",
          receivedEvent.sender(),
          own::proto::Event_PingPong_Name(receivedEvent.action()),
          receivedEvent.ping_count(),
          receivedEvent.pong_count());

        if (receivedEvent.ping_count() == Common::maxCount) { break; }
    }

    return 0;
}
