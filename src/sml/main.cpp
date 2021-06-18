/* example usage of boost-ext/sml
 * Example:
 * stop watch */

#include <boost/sml.hpp>
#include <chrono>
#include <thread>
#include <spdlog/spdlog.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include "logger.h"
#include "states.h"
#include "events.h"
#include "plantumlDump.h"

using namespace std::chrono_literals;

namespace ReallyCoolSM {

std::chrono::time_point<std::chrono::steady_clock> startTime;

struct StopWatchStateMachine
{
  auto operator()() const noexcept
  {
    using namespace boost::sml;

    auto turnOffAction = [](auto) { spdlog::info("turned off"); };
    auto startAction = [&startTime = startTime]() {
      startTime = std::chrono::steady_clock::now();
    };
    auto stopAction = [&startTime = startTime]() {
      const auto diff = std::chrono::steady_clock::now() - startTime;
      spdlog::info("Elasped time: {}s", std::chrono::duration_cast<std::chrono::seconds>(diff).count());
    };

    const auto turnedOff = state<class turnedOff>;

    return make_transition_table(
      // clang-format off
      *turnedOff + event<turnOn> = state<Idle>
      , state<Idle> + event<start> / startAction = state<Running>
      , state<Running> + event<stop> / stopAction = state<Stopped>
      , state<Running> + event<reset> = state<Idle>
      , state<Stopped> + event<reset> = state<Idle>
      , state<Stopped> + event<turnOff> / turnOffAction = X
      // clang-format on
    );
  }
};
}// namespace ReallyCoolSM

int main()
{
  CustomLogger logger;
  boost::sml::sm<ReallyCoolSM::StopWatchStateMachine, boost::sml::logger<CustomLogger>> sm{ logger };

  sm.process_event(turnOn{});

  sm.process_event(start{});
  std::this_thread::sleep_for(1s);
  sm.process_event(stop{});

  sm.process_event(reset{});

  sm.process_event(start{});

  sm.process_event(reset{});

  sm.process_event(start{});
  std::this_thread::sleep_for(1s);
  sm.process_event(stop{});

  sm.process_event(turnOff{});

  dump(sm);
  return 0;
}
