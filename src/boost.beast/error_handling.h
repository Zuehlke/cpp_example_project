#pragma once
#include <boost/beast/core.hpp>
#include <boost/beast/http.hpp>
#include <boost/beast/version.hpp>
#include <boost/asio/dispatch.hpp>
#include <boost/asio/strand.hpp>
#include <fmt/format.h>

namespace beast = boost::beast;// from <boost/beast.hpp>
namespace http = beast::http;// from <boost/beast/http.hpp>
namespace asio = boost::asio;// from <boost/asio.hpp>
using tcp = boost::asio::ip::tcp;// from <boost/asio/ip/tcp.hpp>


inline void fail(beast::error_code ec, char const *what) { fmt::format("FAILED {0}: {1}", what, ec.message()); }
