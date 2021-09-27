#pragma once
#include <fmt/format.h>

namespace beast = boost::beast;// from <boost/beast.hpp>
namespace http = beast::http;// from <boost/beast/http.hpp>
namespace net = boost::asio;// from <boost/asio.hpp>
using tcp = boost::asio::ip::tcp;// from <boost/asio/ip/tcp.hpp>


void fail(beast::error_code ec, char const *what) { fmt::format("FAILED {0}: {1}", what, ec.message()); }
