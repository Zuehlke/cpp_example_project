#pragma once

std::chrono::time_point<std::chrono::steady_clock> startTime;

struct turnOffAction
{
  void operator()() { spdlog::info("turned off"); }
} turnOffAction;

struct startAction
{
  void operator()() { startTime = std::chrono::steady_clock::now(); }
} startAction;

struct stopAction
{
  void operator()()
  {
    const auto diff = std::chrono::steady_clock::now() - startTime;
    spdlog::info("Elasped time: {}s", std::chrono::duration_cast<std::chrono::seconds>(diff).count());
  }
} stopAction;