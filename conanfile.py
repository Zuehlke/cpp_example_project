import os

import conans.model.requires
from conan import ConanFile
from conan.tools.cmake import CMakeToolchain


class HelloConan(ConanFile):
    settings = 'os', 'compiler', 'build_type', 'arch'
    generators = 'CMakeDeps', 'CMakeToolchain'
    default_options = {'fmt/*:header_only': True, 'spdlog/*:header_only': True, 'qt/*:with_fontconfig': False}

    def configure(self):
        cmake = CMakeToolchain(self)
        cmake.user_presets_path = None
        if self.settings.get_safe('arch') == 'armv7':
            self.requires = conans.model.requires.Requirements(['fmt/11.0.2', 'sml/1.1.11'])
            return

        if os.getenv("CONFIGURE_QT") == '1':
            self.requires = conans.model.requires.Requirements(['catch2/3.7.1', 'docopt.cpp/0.6.3', 'gtest/1.15.0',
                                                                'qt/6.7.3', 'spdlog/1.15.0'])
        else:
            requirement = ['catch2/3.7.1', 'gtest/1.15.0', 'docopt.cpp/0.6.3',
                           'spdlog/1.15.0', 'sml/1.1.11', 'nlohmann_json/3.11.3',
                           'boost/1.86.0', 'crowcpp-crow/1.2.0', 'cppzmq/4.10.0',
                           'protobuf/5.27.0']
            self.requires = conans.model.requires.Requirements(requirement)

    def build(self):
        cmake = CMakeToolchain(self)
        cmake.configure()
        cmake.build()
