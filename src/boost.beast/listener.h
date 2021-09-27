#pragma once
#include "helper.h"
#include "data.h"
#include "session.h"

// Accepts incoming connections and launches the sessions
class Listener : public std::enable_shared_from_this<Listener>
{
  public:
    Listener(net::io_context &ioc, const tcp::endpoint &endpoint) : m_ioc(ioc), m_acceptor(net::make_strand(ioc))
    {
        beast::error_code ec;

        // Open the acceptor
        m_acceptor.open(endpoint.protocol(), ec);
        if (ec)
        {
            fail(ec, "open");
            return;
        }

        // Allow address reuse
        m_acceptor.set_option(net::socket_base::reuse_address(true), ec);
        if (ec)
        {
            fail(ec, "set_option");
            return;
        }

        // Bind to the server address
        m_acceptor.bind(endpoint, ec);
        if (ec)
        {
            fail(ec, "bind");
            return;
        }

        // Start listening for connections
        m_acceptor.listen(net::socket_base::max_listen_connections, ec);
        if (ec)
        {
            fail(ec, "listen");
            return;
        }
    }

    // Start accepting incoming connections
    void run() { doAccept(); }

  private:
    void doAccept()
    {
        // The new connection gets its own strand
        m_acceptor.async_accept(net::make_strand(m_ioc), beast::bind_front_handler(&Listener::onAccept, shared_from_this()));
    }

    void onAccept(beast::error_code ec, tcp::socket socket)
    {
        if (ec)
        {
            fail(ec, "accept");
        }
        else
        {
            // Create the session and run it
            std::make_shared<Session>(std::move(socket), m_persons)->run();
        }

        // Accept another connection
        doAccept();
    }

    net::io_context &m_ioc;
    tcp::acceptor m_acceptor;
    std::vector<data::person> m_persons;
};
