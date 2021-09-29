#pragma once
#include <nlohmann/json.hpp>
#include <string>

namespace data {
// a simple struct to model a person
struct person
{
    std::string name;
    std::string address;
    int age = {0};
    int id = {0};
};

inline void to_json(nlohmann::json &j, const person &p) { j = nlohmann::json{ { "name", p.name }, { "address", p.address }, { "age", p.age }, { "id", p.id } }; }

inline void from_json(const nlohmann::json &j, person &p)
{
    j.at("name").get_to(p.name);
    j.at("address").get_to(p.address);
    j.at("age").get_to(p.age);
    j.at("id").get_to(p.id);
}
}// namespace data
