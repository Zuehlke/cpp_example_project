#include "event.pb.h"
#include <chrono>
#include <include/common.h>
#include <thread>

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

    zmq::message_t request{};
    for (;;) {
        // receive a request from client
        socket.recv(request, zmq::recv_flags::none);
        // simulate work
        std::this_thread::sleep_for(500ms);

        auto [receivedEvent, serializedData] = Common::prepareMessage(senderName, request);
        serializedData = Common::incrementPingPong(receivedEvent, own::proto::Event::PING);
        Common::logProtoEvent(receivedEvent);

          // send the reply to the client
        socket.send(zmq::buffer(serializedData), zmq::send_flags::none);

        if (receivedEvent.ping_count() == Common::maxCount) { break; }
    }

    return 0;
}
