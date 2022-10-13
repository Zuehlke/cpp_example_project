#include <spdlog/spdlog.h>
#include <zmq.hpp>

namespace Common {
constexpr auto maxCount = 10;

std::tuple<own::proto::Event, std::string> prepareMessage(const std::string &senderName, const zmq::message_t &request)
{
    own::proto::Event receivedEvent{};
    std::string data;
    receivedEvent.ParseFromArray(request.data(), static_cast<int>(request.size()));

    own::proto::Event event{};
    event.set_sender(senderName);
    event.SerializeToString(&data);
    return std::make_tuple(receivedEvent, data);
}

[[nodiscard]]std::string incrementPingPong(own::proto::Event& event, own::proto::Event_PingPong eventType)
{
    switch (eventType) {
    case own::proto::Event::PING: {
        event.set_action(own::proto::Event::PING);
        event.set_ping_count(event.ping_count() + 1);
        event.set_pong_count(event.pong_count());
    }
    case own::proto::Event::PONG: {
        event.set_action(own::proto::Event::PONG);
        event.set_ping_count(event.ping_count());
        event.set_pong_count(event.pong_count() + 1);
        break;
    }
    default: {
        break;
    }
    }
    std::string data;
    event.SerializeToString(&data);
    return data;
}

void logProtoEvent(const own::proto::Event &receivedEvent)
{
    spdlog::info("Received from: {} - Action: {} - Ping count: {} - Pong count: {}",
      receivedEvent.sender(),
      own::proto::Event_PingPong_Name(receivedEvent.action()),
      receivedEvent.ping_count(),
      receivedEvent.pong_count());
}
}// namespace Common
