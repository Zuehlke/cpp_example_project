#include "listener.h"
#include <cstdlib>
#include <memory>
#include <thread>
#include <vector>


int main()
{
    const auto address = asio::ip::make_address("0.0.0.0");
    const uint16_t port = 8080u;
    const auto threads = 1;

    // The io_context is required for all I/O
    asio::io_context ioc{ threads };

    // Create and launch a listening port
    std::make_shared<Listener>(ioc, tcp::endpoint{ address, port })->run();

    // Run the I/O service on the requested number of threads
    std::vector<std::thread> v;
    v.reserve(threads);
    for (auto i = 0; i < threads; i++) {
        v.emplace_back([&ioc] { ioc.run(); });
    }
    ioc.run();

    return EXIT_SUCCESS;
}
