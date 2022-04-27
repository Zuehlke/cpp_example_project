#pragma once
#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio/dispatch.hpp>
#include <boost/asio/strand.hpp>
#include <fmt/format.h>

// from <boost/beast.hpp>
namespace beast = boost::beast;
// from <boost/beast/http.hpp>
namespace http = beast::http;
// from <boost/asio.hpp>
namespace asio = boost::asio;
// from <boost/asio/ip/tcp.hpp>
using tcp = boost::asio::ip::tcp;


inline void fail(beast::error_code ec, char const *what) { fmt::format("FAILED {0}: {1}", what, ec.message()); }
