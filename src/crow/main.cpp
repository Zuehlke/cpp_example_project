/* example usage of crow-cpp http://crowcpp.org/ */
#include "crow.h"

class a : public crow::returnable
{
public:
  a() : returnable("text/plain"){};

  std::string dump() const override
  {
    return "ABCDF";
  }
};

int main()
{
  constexpr uint16_t port = 8080;
  std::vector<int> values;
  crow::SimpleApp app;

  CROW_ROUTE(app, "/")
  ([]() {
    return "Hello world";
  });

  CROW_ROUTE(app, "/json")
  ([] {
    crow::json::wvalue returnValue({ { "message", "Hello, World!" } });
    returnValue["message2"] = "Hello, World.. Again!";
    return returnValue;
  });

  CROW_ROUTE(app, "/custom")
  ([] {
    return a();
  });

  CROW_ROUTE(app, "/hello/<int>").methods(crow::HTTPMethod::POST)([&values](int count) {
    values.push_back(count);
    return crow::response(std::to_string(count));
  });

  CROW_ROUTE(app, "/hello/").methods(crow::HTTPMethod::GET)([&values]() {
    crow::json::wvalue returnValue;
    returnValue["values"] = values;
    return returnValue;
  });

  app.port(port).run();
  return 0;
}
