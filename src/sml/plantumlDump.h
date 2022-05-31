#pragma once
#include <fstream>

namespace sml = boost::sml;

template<class T> void dump_transition(std::ofstream &ofs) noexcept
{
    auto src_state = std::string{ sml::aux::string<typename T::src_state>{}.c_str() };
    auto dst_state = std::string{ sml::aux::string<typename T::dst_state>{}.c_str() };
    if (dst_state == "X") { dst_state = "[*]"; }

    if (T::initial) { ofs << "[*] --> " << src_state << "\n"; }

    const auto has_event = !sml::aux::is_same<typename T::event, sml::anonymous>::value;
    const auto has_guard = !sml::aux::is_same<typename T::guard, sml::front::always>::value;
    const auto has_action = !sml::aux::is_same<typename T::action, sml::front::none>::value;

    const auto is_entry = sml::aux::is_same<typename T::event, sml::back::on_entry<sml::_, sml::_>>::value;
    const auto is_exit = sml::aux::is_same<typename T::event, sml::back::on_exit<sml::_, sml::_>>::value;

    if (is_entry || is_exit) {
        ofs << src_state;
    } else {// state to state transition
        ofs << src_state << " --> " << dst_state;
    }

    if (has_event || has_guard || has_action) { ofs << " :"; }

    if (has_event) {
        auto event = std::string(boost::sml::aux::get_type_name<typename T::event>());
        if (is_entry) {
            event = "entry";
        } else if (is_exit) {
            event = "exit";
        }
        ofs << " " << event;
    }

    if (has_guard) { ofs << " [" << boost::sml::aux::get_type_name<typename T::guard::type>() << "]"; }

    if (has_action) { ofs << " / " << boost::sml::aux::get_type_name<typename T::action::type>(); }

    ofs << "\n";
}

template<template<class...> class T, class... Ts> void dump_transitions(std::ofstream &ofs, const T<Ts...> &) noexcept
{
    int _[]{ 0, (dump_transition<Ts>(ofs), 0)... };
    (void)_;
}

template<class SM> void dump(const SM &) noexcept
{
    std::ofstream ofs("stateMachine.plantuml");
    ofs << "@startuml\n\n";
    dump_transitions(ofs, typename SM::transitions{});
    ofs << std::endl << "@enduml\n";
}
