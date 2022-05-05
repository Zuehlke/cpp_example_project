#pragma once
#include "error_handling.h"
#include "request.h"

// Handles an HTTP server connection
class Session : public std::enable_shared_from_this<Session>
{
  public:
    // Take ownership of the stream
    explicit Session(tcp::socket &&socket, std::vector<data::person> &person) : m_person(person), m_stream(std::move(socket)), m_lambda(*this) {}

    // Start the asynchronous operation
    void run()
    {
        // We need to be executing within a strand to perform async operations
        // on the I/O objects in this session. Although not strictly necessary
        // for single-threaded contexts, this example code is written to be
        // thread-safe by default.
        asio::dispatch(m_stream.get_executor(), beast::bind_front_handler(&Session::doRead, shared_from_this()));
    }

    void doRead()
    {
        // Make the request empty before reading,
        // otherwise the operation behavior is undefined.
        m_req = {};

        // Set the timeout.
        m_stream.expires_after(std::chrono::seconds(30));

        // Read a request
        http::async_read(m_stream, m_buffer, m_req, beast::bind_front_handler(&Session::onRead, shared_from_this()));
    }

    void onRead(beast::error_code ec, std::size_t bytes_transferred)
    {
        boost::ignore_unused(bytes_transferred);

        // This means they closed the connection
        if (ec == http::error::end_of_stream) { return doClose(); }

        if (ec) { return fail(ec, "read"); }

        // Send the response
        handleRequest(std::move(m_req), m_lambda, m_person);
    }

    void onWrite(bool close, beast::error_code ec, std::size_t bytes_transferred)
    {
        boost::ignore_unused(bytes_transferred);

        if (ec) { return fail(ec, "write"); }

        if (close) {
            // This means we should close the connection, usually because
            // the response indicated the "Connection: close" semantic.
            return doClose();
        }

        // We're done with the response so delete it
        m_res = nullptr;

        // Read another request
        doRead();
    }

    void doClose()
    {
        // Send a TCP shutdown
        beast::error_code ec;
        m_stream.socket().shutdown(tcp::socket::shutdown_send, ec);

        // At this point the connection is closed gracefully
    }

  private:
    std::vector<data::person> &m_person;

    // The function object is used to send an HTTP message.
    struct sendLambda
    {
      public:
        explicit sendLambda(Session &self) : m_self(self) {}

        template<bool isRequest, class Body, class Fields> void operator()(http::message<isRequest, Body, Fields> &&msg) const
        {
            // The lifetime of the message has to extend
            // for the duration of the async operation so
            // we use a shared_ptr to manage it.
            auto sp = std::make_shared<http::message<isRequest, Body, Fields>>(std::move(msg));

            // Store a type-erased version of the shared
            // pointer in the class to keep it alive.
            m_self.m_res = sp;

            // Write the response
            http::async_write(m_self.m_stream, *sp, beast::bind_front_handler(&Session::onWrite, m_self.shared_from_this(), sp->need_eof()));
        }

      private:
        Session &m_self;
    };
    beast::tcp_stream m_stream;
    beast::flat_buffer m_buffer;
    http::request<http::string_body> m_req;
    std::shared_ptr<void> m_res;
    sendLambda m_lambda;
};
