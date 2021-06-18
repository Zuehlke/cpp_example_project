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
#include "actions.h"
#include "plantumlDump.h"

using namespace std::chrono_literals;

namespace ReallyCoolSM {


struct StopWatchStateMachine
{
  auto operator()() const noexcept
  {
    using namespace boost::sml;

    return make_transition_table(
      // clang-format off
      *state<TurnedOff> + event<turnOn> = state<Idle>
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
