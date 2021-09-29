#pragma once
#include "error_handling.h"

template<typename Request> http::response<http::string_body> inline createResponse(Request &&req, http::status status, const nlohmann::json &jsonResponse)
{
    http::response<http::string_body> res{ status, req.version() };
    res.set(http::field::server, BOOST_BEAST_VERSION_STRING);
    res.set(http::field::content_type, "application/json");
    res.keep_alive(req.keep_alive());
    res.body() = jsonResponse.dump();
    res.prepare_payload();
    return res;
}


// This function produces an HTTP response for the given
// request. The type of the response object depends on the
// contents of the request, so the interface requires the
// caller to pass a generic lambda for receiving the response.
template<class Body, class Allocator, class Send> inline void handleRequest(http::request<Body, http::basic_fields<Allocator>> &&req, Send &&send, std::vector<data::person> &data)
{
    // Returns a bad request response
    const auto badRequest = [&req](beast::string_view why) {
        const auto j = nlohmann::json::parse(std::string(why));
        return createResponse(req, http::status::bad_request, j);
    };

    // Make sure we can handle the method
    switch (req.method())
    {
    case http::verb::get: {
        // Respond to GET request
        nlohmann::json j = data;
        return send(std::move(createResponse(req, http::status::ok, j)));
    }
    case http::verb::put: {
        try
        {
            const auto j = nlohmann::json::parse(req.body());
            const data::person d = j;
            if (d.id > data.size() - 1 || d.id < 0)
            {
                const nlohmann::json j = R"({"error": "id is larger than data list or negative"})";
                return send(std::move(createResponse(req, http::status::internal_server_error, j)));
            }
            auto &temp = data.at(d.id - 1);
            temp.name = d.name;
            temp.address = d.address;
            temp.age = d.age;
            return send(std::move(createResponse(req, http::status::ok, j)));
        }
        catch (nlohmann::json::exception &e)
        {
            return send(std::move(badRequest(e.what())));
        }
    }
    case http::verb::post: {
        try
        {
            const auto j = nlohmann::json::parse(req.body());
            data.push_back(j);
            data.back().id = static_cast<int>(data.size());
            return send(std::move(createResponse(req, http::status::ok, j)));
        }
        catch (nlohmann::json::exception &e)
        {
            return send(std::move(badRequest(e.what())));
        }
    }
    default: {
        const nlohmann::json j = R"({"error": "http method not supported"})";
        return send(std::move(createResponse(req, http::status::internal_server_error, j)));
    }
    }
}